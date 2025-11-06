Seeding Guide – Firestore & Storage

Collections covered (MVP)
- services (ServiceProduit)
- clients (Client)
- contacts (MessageContact)

Option A – Firestore Console Import (manual)
1) Open Firebase Console → Firestore Database.
2) Create collection `services` → Add documents from `docs/seeds/services.json` (copy/paste per doc).
3) Create collection `clients` → Add documents from `docs/seeds/clients.json`.
4) Create collection `contacts` → Add documents from `docs/seeds/contacts.json`.

Option B – Admin Script (Node.js) – sample snippet
```js
// run: node seed.js (with GOOGLE_APPLICATION_CREDENTIALS set)
import { readFileSync } from 'fs';
import { Firestore } from '@google-cloud/firestore';

const db = new Firestore();

async function seedCollection(name, jsonPath, idField) {
  const items = JSON.parse(readFileSync(jsonPath, 'utf8'));
  for (const item of items) {
    const docId = item[idField] || undefined;
    const ref = docId ? db.collection(name).doc(docId) : db.collection(name).doc();
    await ref.set(item, { merge: true });
    console.log(`Seeded ${name}/${ref.id}`);
  }
}

await seedCollection('services', 'docs/seeds/services.json', 'id');
await seedCollection('clients', 'docs/seeds/clients.json', 'uid');
await seedCollection('contacts', 'docs/seeds/contacts.json', 'id');
```

Storage note
- If you reference `imageURL` paths, upload corresponding files to Storage and make them readable according to your rules.

Security rules reminder
- Ensure rules restrict write to admins and read scoped to clients where appropriate.


