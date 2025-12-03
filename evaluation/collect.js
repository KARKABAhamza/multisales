#!/usr/bin/env node
/**
 * Evaluation runner: executes seed script with parameters from queries.json and validates Firestore write.
 */
const fs = require('fs');
const path = require('path');

function sh(cmd) { return new Promise((resolve, reject) => {
  const cp = require('child_process').spawn(cmd[0], cmd.slice(1), { stdio: 'inherit', shell: process.platform === 'win32' });
  cp.on('exit', (code) => (code === 0 ? resolve() : reject(new Error('Command failed: ' + cmd.join(' ')))));
}); }

async function main() {
  const args = parseArgs(process.argv.slice(2));
  const queries = JSON.parse(fs.readFileSync(path.resolve('evaluation/queries.json'), 'utf8'));
  const seed = queries.seed_script[0];

  if (!args.credentials) {
    console.error('Missing --credentials path to serviceAccount.json');
    process.exit(1);
  }

  const seedCmd = ['node', 'scripts/seed_contact.js', '--credentials', args.credentials];
  if (args.project) seedCmd.push('--project', args.project);
  if (seed.phone) seedCmd.push('--phone', seed.phone);
  if (seed.email) seedCmd.push('--email', seed.email);
  if (seed.address) seedCmd.push('--address', seed.address);
  if (seed.hours) seedCmd.push('--hours', seed.hours);

  console.log('Running seed script...');
  await sh(seedCmd);
  console.log('Seed script completed. Verifying Firestore document...');
  const admin = require('firebase-admin');
  const cred = JSON.parse(fs.readFileSync(path.resolve(args.credentials), 'utf8'));
  const verifyApp = admin.initializeApp({ credential: admin.credential.cert(cred), projectId: args.project || cred.project_id }, 'verify');
  const vdb = admin.firestore(verifyApp);
  const snap = await vdb.collection('settings').doc('contact').get();
  if (!snap.exists) throw new Error('settings/contact not found');
  const data = snap.data();
  const required = ['phone', 'email', 'address', 'hours'];
  const missing = required.filter((k) => !data[k]);
  if (missing.length) throw new Error('Missing fields in settings/contact: ' + missing.join(','));
  // Assert exact seeded values match what we sent
  const mismatches = [];
  if (seed.phone && data.phone !== seed.phone) mismatches.push(`phone expected ${seed.phone} got ${data.phone}`);
  if (seed.email && data.email !== seed.email) mismatches.push(`email expected ${seed.email} got ${data.email}`);
  if (seed.address && data.address !== seed.address) mismatches.push(`address expected ${seed.address} got ${data.address}`);
  if (seed.hours && data.hours !== seed.hours) mismatches.push(`hours expected ${seed.hours} got ${data.hours}`);
  if (mismatches.length) throw new Error('Field mismatches: ' + mismatches.join('; '));
  console.log('Verified Firestore settings/contact with expected fields.');
  await verifyApp.delete();

  console.log('Done.');
}

function parseArgs(argv) {
  const out = {};
  let positional = [];
  for (let i = 0; i < argv.length; i++) {
    const k = argv[i];
    if (k === '--credentials' || k === '-c') out.credentials = argv[++i];
    else if (k === '--project' || k === '-p') out.project = argv[++i];
    else if (k && !k.startsWith('--')) positional.push(k);
  }
  // Support npm run passing positional args without flags:
  if (!out.credentials && positional.length > 0) out.credentials = positional[0];
  if (!out.project && positional.length > 1) out.project = positional[1];
  return out;
}

main().catch((err) => { console.error(err); process.exit(1); });
