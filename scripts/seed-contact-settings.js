#!/usr/bin/env node
/**
 * scripts/seed-contact-settings.js
 * 
 * Seed script to write settings/contact to Firestore using a service account.
 * Use this script in CI or ops workflows to initialize or update contact settings.
 * 
 * Usage:
 *   node scripts/seed-contact-settings.js
 * 
 * Requires:
 *   - GOOGLE_APPLICATION_CREDENTIALS env var pointing to service account JSON
 *   - Or pass --serviceAccount path/to/sa.json
 *   - firebase-admin installed (npm install firebase-admin)
 * 
 * Example:
 *   GOOGLE_APPLICATION_CREDENTIALS=./sa.json node scripts/seed-contact-settings.js
 *   node scripts/seed-contact-settings.js --serviceAccount ./sa.json --projectId multisales-18e57
 */

const admin = require('firebase-admin');

// Parse command-line arguments
const args = process.argv.slice(2);
let serviceAccountPath = process.env.GOOGLE_APPLICATION_CREDENTIALS || null;
let projectId = null;

for (let i = 0; i < args.length; i++) {
  if (args[i] === '--serviceAccount' && args[i + 1]) {
    serviceAccountPath = args[i + 1];
    i++;
  } else if (args[i] === '--projectId' && args[i + 1]) {
    projectId = args[i + 1];
    i++;
  } else if (args[i] === '--help') {
    console.log(`
Usage: node scripts/seed-contact-settings.js [options]

Options:
  --serviceAccount <path>   Path to service account JSON file
  --projectId <id>          Firebase project ID (e.g. multisales-18e57)
  --help                    Show this help message

Environment variables:
  GOOGLE_APPLICATION_CREDENTIALS   Path to service account JSON file

Example:
  node scripts/seed-contact-settings.js --serviceAccount ./sa.json --projectId multisales-18e57
`);
    process.exit(0);
  }
}

// Initialize Firebase Admin SDK
try {
  if (serviceAccountPath) {
    const serviceAccount = require(serviceAccountPath.startsWith('.') ? `../${serviceAccountPath}` : serviceAccountPath);
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
      projectId: projectId || serviceAccount.project_id,
    });
    console.log(`✓ Firebase Admin initialized with service account: ${serviceAccountPath}`);
  } else {
    admin.initializeApp();
    console.log('✓ Firebase Admin initialized with application default credentials');
  }
} catch (error) {
  console.error('✗ Failed to initialize Firebase Admin SDK:', error.message);
  console.error('  Make sure GOOGLE_APPLICATION_CREDENTIALS is set or pass --serviceAccount');
  process.exit(1);
}

const db = admin.firestore();

// Contact settings data to seed
const contactData = {
  phone: '+212 784007410',
  email: 'contact@multisales.ma',
  address: '49 boulevard CHEFCHAOUNI II, Ain Sébaâ, Casablanca Maroc',
  hours: 'Lun–Ven 08:30 – 18:00',
  updatedAt: admin.firestore.FieldValue.serverTimestamp(),
};

async function seedContactSettings() {
  try {
    console.log('Seeding settings/contact document...');
    await db.doc('settings/contact').set(contactData, { merge: true });
    console.log('✓ Contact settings seeded successfully!');
    console.log('  Document: settings/contact');
    console.log('  Data:', JSON.stringify(contactData, null, 2));
    process.exit(0);
  } catch (error) {
    console.error('✗ Failed to seed contact settings:', error.message);
    process.exit(1);
  }
}

seedContactSettings();
