const fs = require('fs');
const path = require('path');
const { initializeTestEnvironment, assertFails, assertSucceeds } = require('@firebase/rules-unit-testing');

let testEnv;

before(async () => {
  const rules = fs.readFileSync(path.join(__dirname, '../../firestore.rules'), 'utf8');
  testEnv = await initializeTestEnvironment({
    projectId: 'demo-test',
    firestore: { rules },
  });
});

after(async () => {
  await testEnv.cleanup();
});

describe('Firestore security rules', function () {
  it('settings/contact read allowed for authenticated users', async () => {
    const user = testEnv.authenticatedContext('user123');
    const db = user.firestore();
    const docRef = db.doc('settings/contact');
    await assertSucceeds(docRef.get());
  });

  it('settings/contact write restricted to admin/manager', async () => {
    const user = testEnv.authenticatedContext('user456', { role: 'employee' });
    const db = user.firestore();
    const docRef = db.doc('settings/contact');
    await assertFails(docRef.set({ phone: '+1', email: 'x@y.com' }));

    const admin = testEnv.authenticatedContext('admin1', { role: 'admin' });
    const adb = admin.firestore();
    await assertSucceeds(adb.doc('settings/contact').set({ phone: '+1', email: 'x@y.com' }));
  });
});
