#!/usr/bin/env node
/**
 * Standalone seed script to write Firestore document `settings/contact`.
 * Usage:
 *   node scripts/seed_contact.js --credentials path/to/serviceAccount.json [--project your-project-id]
 * Or set env var GOOGLE_APPLICATION_CREDENTIALS to the JSON path and omit --credentials.
 */

const fs = require('fs');
const path = require('path');

async function main() {
  // Optional tracing: send spans to local OTLP (AI Toolkit)
  try {
    const { NodeSDK } = require('@opentelemetry/sdk-node');
    const { OTLPTraceExporter } = require('@opentelemetry/exporter-trace-otlp-http');
    const sdk = new NodeSDK({
      traceExporter: new OTLPTraceExporter({ url: 'http://localhost:4318/v1/traces' }),
    });
    await sdk.start();
  } catch (_) {
    // tracing is optional; continue if not installed
  }
  const args = parseArgs(process.argv.slice(2));
  const credPath = args.credentials || process.env.GOOGLE_APPLICATION_CREDENTIALS;
  const projectId = args.project || process.env.GCLOUD_PROJECT || process.env.GCP_PROJECT || process.env.FIREBASE_CONFIG_PROJECT;

  if (!credPath || !fs.existsSync(credPath)) {
    console.error('Missing or invalid credentials. Provide --credentials path/to/serviceAccount.json or set GOOGLE_APPLICATION_CREDENTIALS.');
    process.exit(1);
  }

  const admin = require('firebase-admin');
  const serviceAccount = JSON.parse(fs.readFileSync(path.resolve(credPath), 'utf8'));

  const app = admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    projectId: projectId || serviceAccount.project_id,
  });

  const db = admin.firestore(app);

  const contactDoc = {
    phone: args.phone || '+212 6 12 34 56 78',
    email: args.email || 'contact@multisales.com',
    address: args.address || 'Avenue Exemple, Casablanca, Maroc',
    hours: args.hours || 'Lun–Ven, 9:00–18:00',
    updatedAt: new Date().toISOString(),
  };

  await db.collection('settings').doc('contact').set(contactDoc, { merge: true });
  console.log('Seeded settings/contact successfully.');
  await app.delete();
}

function parseArgs(argv) {
  const out = {};
  for (let i = 0; i < argv.length; i++) {
    const k = argv[i];
    if (k === '--credentials' || k === '-c') out.credentials = argv[++i];
    else if (k === '--project' || k === '-p') out.project = argv[++i];
    else if (k === '--phone') out.phone = argv[++i];
    else if (k === '--email') out.email = argv[++i];
    else if (k === '--address') out.address = argv[++i];
    else if (k === '--hours') out.hours = argv[++i];
  }
  return out;
}

main().catch((err) => {
  console.error('Seed failed:', err);
  process.exit(1);
});
