/**
 * functions/index.js
 * Fonctions Cloud pour MULTISALES
 *
 * Fonctions incluses :
 *  - onOrderCreate : trigger Firestore orders/{orderId} -> décrémente le stock et crée une notification
 *  - onUserCreate  : trigger Auth user creation -> crée le profil utilisateur dans Firestore
 *  - getSignedUploadUrl : callable HTTPS -> retourne une URL signée pour upload direct vers Storage
 *
 * Déployer : dans le dossier functions : npm install && firebase deploy --only functions --project=multisales-18e57
 */

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { google } = require('googleapis');
const sgMail = require('@sendgrid/mail');

admin.initializeApp();

// Shortcuts
const db = admin.firestore();
const logger = functions.logger;

// SendGrid configuration (from Firebase Functions config, Secrets Manager, or environment)
const SENDGRID_KEY = (functions.config().sendgrid && functions.config().sendgrid.key) || process.env.SENDGRID_KEY;
const RESOLVED_SENDGRID_KEY = process.env.SENDGRID_API_KEY || SENDGRID_KEY; // Prefer Secret Manager when available
const SENDGRID_FROM = (functions.config().sendgrid && functions.config().sendgrid.from) || process.env.SENDGRID_FROM;
const SENDGRID_TO = (functions.config().sendgrid && functions.config().sendgrid.to) || process.env.SENDGRID_TO;

if (RESOLVED_SENDGRID_KEY) {
  try {
    sgMail.setApiKey(RESOLVED_SENDGRID_KEY);
  } catch (e) {
    logger.warn('SendGrid API key set failed', { error: e.toString() });
  }
} else {
  logger.warn('SendGrid API key not configured. Emails will not be sent.');
}

/**
 * onOrderCreate
 * Décrémente le stock pour chaque item et crée une notification.
 * Attente: document order contient { items: [ { productId, qty, unitPrice } ], userId }
 */
exports.onOrderCreate = functions.firestore
  .document('orders/{orderId}')
  .onCreate(async (snap, context) => {
    const order = snap.data();
    const orderId = context.params.orderId;

    if (!order) {
      logger.warn('onOrderCreate: order snapshot empty', { orderId });
      return null;
    }

    const items = Array.isArray(order.items) ? order.items : [];
    if (items.length === 0) {
      logger.info('onOrderCreate: no items to process', { orderId });
    }

    try {
      // Use a transaction or batch to update stock safely
      const batch = db.batch();

      for (const it of items) {
        if (!it.productId || !it.qty) {
          logger.warn('onOrderCreate: skipping invalid item', { item: it, orderId });
          continue;
        }
        const prodRef = db.collection('products').doc(it.productId.toString());
        // Decrement stock by qty (will create field if absent - optionally check first)
        batch.update(prodRef, { stock: admin.firestore.FieldValue.increment(-Math.abs(it.qty)) });
      }

      await batch.commit();
      logger.info('onOrderCreate: stock updated', { orderId, itemCount: items.length });

      // Create a notification document for admin/ops
      const notifRef = db.collection('notifications').doc();
      await notifRef.set({
        title: 'Nouvelle commande',
        body: `Commande ${orderId} créée (${items.length} article(s))`,
        data: { orderId, userId: order.userId || null },
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        read: false,
      });

      logger.info('onOrderCreate: notification created', { orderId, notifId: notifRef.id });
      return null;
    } catch (err) {
      logger.error('onOrderCreate: failed', { error: err.toString(), orderId });
      // Optionally write an error document
      await db.collection('functionErrors').add({
        function: 'onOrderCreate',
        error: err.toString(),
        orderId,
        ts: admin.firestore.FieldValue.serverTimestamp(),
      });
      throw err;
    }
  });

/**
 * onUserCreate
 * Lorsqu'un utilisateur est créé via Firebase Auth : crée son profil Firestore sous users/{uid}
 */
exports.onUserCreate = functions.auth.user().onCreate(async (user) => {
  try {
    const uid = user.uid;
    const userDoc = db.collection('users').doc(uid);
    const payload = {
      email: user.email || null,
      displayName: user.displayName || null,
      photoURL: user.photoURL || null,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      roles: { customer: true }, // par défaut
    };

    await userDoc.set(payload, { merge: true });
    logger.info('onUserCreate: user profile created', { uid });
    return null;
  } catch (err) {
    logger.error('onUserCreate: failed', { error: err.toString() });
    throw err;
  }
});

/**
 * getSignedUploadUrl (callable)
 * Permet au client authentifié de demander une URL signée pour PUT direct vers Cloud Storage
 * Input (data): { path: "products/{productId}/images/filename.jpg", contentType: "image/jpeg", expiresInSeconds?: 300 }
 * Output: { uploadUrl, publicUrl, path }
 *
 * Usage client JS:
 * const callable = firebase.functions().httpsCallable('getSignedUploadUrl');
 * const res = await callable({ path: 'products/123/images/photo.jpg', contentType: 'image/jpeg' });
 * const { uploadUrl, publicUrl } = res.data;
 *
 * Note: pour Flutter, utilise cloud_functions package pour appeler la callable function.
 */
exports.getSignedUploadUrl = functions.https.onCall(async (data, context) => {
  // authenticated only
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Authentication required.');
  }

  const uid = context.auth.uid;
  const path = data && data.path ? data.path.toString() : null;
  const contentType = data && data.contentType ? data.contentType.toString() : 'application/octet-stream';
  const expiresInSeconds = Number(data && data.expiresInSeconds ? data.expiresInSeconds : 300);

  if (!path) {
    throw new functions.https.HttpsError('invalid-argument', 'Missing "path" parameter.');
  }
  if (expiresInSeconds <= 0 || expiresInSeconds > 3600) {
    throw new functions.https.HttpsError('invalid-argument', 'expiresInSeconds must be between 1 and 3600.');
  }

  try {
    const bucket = admin.storage().bucket(); // default bucket
    const file = bucket.file(path);

    // Create signed URL for direct PUT/WRITE
    const options = {
      version: 'v4',
      action: 'write',
      contentType: contentType,
      expires: Date.now() + expiresInSeconds * 1000,
    };

    const [uploadUrl] = await file.getSignedUrl(options);

    // Public URL for read (depending on your bucket policy, you may need to set file ACL)
    const publicUrl = `https://storage.googleapis.com/${bucket.name}/${encodeURIComponent(path)}`;

    // Optionally record an "upload intent" for later verification
    await db.collection('uploads').add({
      path,
      createdBy: uid,
      contentType,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      expiresAt: admin.firestore.Timestamp.fromMillis(Date.now() + expiresInSeconds * 1000),
    });

    logger.info('getSignedUploadUrl: signed url created', { uid, path, expiresInSeconds });
    return { uploadUrl, publicUrl, path };
  } catch (err) {
    logger.error('getSignedUploadUrl: failed', { error: err.toString(), uid, path });
    throw new functions.https.HttpsError('internal', 'Unable to create signed URL.');
  }
});

/**
 * scheduledFirestoreExport
 * Exporte la base Firestore quotidiennement dans un bucket Cloud Storage.
 * Le job Cloud Scheduler est géré automatiquement par Firebase lors du déploiement.
 */
exports.scheduledFirestoreExport = functions.pubsub
  .schedule('0 2 * * *') // Tous les jours à 02:00
  .timeZone('Africa/Casablanca')
  .onRun(async () => {
    const projectId = process.env.GCLOUD_PROJECT;
    const bucketName = admin.storage().bucket().name;

    if (!projectId || !bucketName) {
      logger.error('scheduledFirestoreExport: missing projectId or bucketName', { projectId, bucketName });
      return null;
    }

    const dateStr = new Date().toISOString().slice(0, 10).replace(/-/g, '');
    const outputUriPrefix = `gs://${bucketName}/firestore-backups/${dateStr}`;

    try {
      const auth = await google.auth.getClient({
        scopes: [
          'https://www.googleapis.com/auth/datastore',
          'https://www.googleapis.com/auth/cloud-platform',
        ],
      });

      const firestore = google.firestore({ version: 'v1', auth });
      const name = `projects/${projectId}/databases/(default)`;

      await firestore.projects.databases.exportDocuments({
        name,
        requestBody: {
          outputUriPrefix,
          // Ajoutez collectionIds si vous voulez exporter seulement certaines collections
          // collectionIds: ['products', 'orders', 'users']
        },
      });

      logger.info('scheduledFirestoreExport: export started', { outputUriPrefix });
      return null;
    } catch (err) {
      logger.error('scheduledFirestoreExport: failed', { error: err.toString(), outputUriPrefix });
      await db.collection('functionErrors').add({
        function: 'scheduledFirestoreExport',
        error: err.toString(),
        ts: admin.firestore.FieldValue.serverTimestamp(),
        outputUriPrefix,
      });
      throw err;
    }
  });

/**
 * sendContactEmail (callable)
 * Input: { name, email, message }
 * - Enregistre le message dans Firestore (collection 'contacts')
 * - Envoie un email via SendGrid si configuré
 * Output: { success: true, savedId, emailSent }
 */
exports.sendContactEmail = functions
  .runWith({ secrets: ['SENDGRID_API_KEY'] })
  .https.onCall(async (data, context) => {
  const name = data && data.name ? String(data.name).trim() : '';
  const email = data && data.email ? String(data.email).trim() : '';
  const message = data && data.message ? String(data.message).trim() : '';

  if (!name || !email || !message) {
    throw new functions.https.HttpsError('invalid-argument', 'name, email and message are required.');
  }

  // Save to Firestore first
  let docRef;
  try {
    docRef = await db.collection('contacts').add({
      name,
      email,
      message,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      status: 'new',
      source: 'web',
    });
    logger.info('Contact saved', { id: docRef.id });
  } catch (err) {
    logger.error('Failed to save contact', { error: err.toString() });
    throw new functions.https.HttpsError('internal', 'Failed to save contact.');
  }

  // Send email if configured
  if (RESOLVED_SENDGRID_KEY && SENDGRID_FROM && SENDGRID_TO) {
    const subject = `Nouveau message contact - ${name}`;
    const html = `
      <p>Vous avez reçu un nouveau message via le formulaire Contact MULTISALES :</p>
      <ul>
        <li><strong>Nom :</strong> ${escapeHtml(name)}</li>
        <li><strong>Email :</strong> ${escapeHtml(email)}</li>
        <li><strong>ID Firestore :</strong> ${docRef.id}</li>
      </ul>
      <h4>Message</h4>
      <p>${escapeHtml(message).replace(/\n/g, '<br/>')}</p>
    `;

    const msg = {
      to: SENDGRID_TO,
      from: SENDGRID_FROM,
      subject,
      html,
      replyTo: email,
    };

    try {
      await sgMail.send(msg);
      logger.info('SendGrid: email sent', { to: SENDGRID_TO, contactId: docRef.id });
    } catch (err) {
      logger.error('SendGrid: failed to send email', { error: err.toString() });
      return { success: true, savedId: docRef.id, emailSent: false, message: 'Contact saved but email failed.' };
    }
  } else {
    logger.warn('SendGrid config missing: skipped email send.');
    return { success: true, savedId: docRef.id, emailSent: false, message: 'Contact saved (no email configured).' };
  }

  return { success: true, savedId: docRef.id, emailSent: true };
});

function escapeHtml(unsafe) {
  return String(unsafe)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;');
}
