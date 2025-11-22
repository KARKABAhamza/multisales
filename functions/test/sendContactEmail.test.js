const assert = require('assert');
const proxyquire = require('proxyquire');
let ftest;

describe('sendContactEmail', () => {
  let wrapped;

  before(function () {
    this.timeout(10000);
    // Ensure SendGrid is not configured so code follows the 'no email configured' path
    process.env.SENDGRID_API_KEY = '';

    // Build a mock firebase-admin to inject into the module. This avoids any
    // real network calls or credential lookups during require-time.
    const mockDb = {
      collection: (name) => ({
        add: async (doc) => ({ id: 'mockedId' }),
      }),
    };

    const mockAdmin = {
      initializeApp: () => {},
      firestore: () => mockDb,
    };
    // Provide FieldValue and Timestamp helpers used by index.js
    mockAdmin.firestore.FieldValue = {
      serverTimestamp: () => ({ _mock: 'serverTimestamp' }),
      increment: (n) => ({ _mockIncrement: n }),
    };
    mockAdmin.firestore.Timestamp = {
      fromMillis: (ms) => ({ _mockMillis: ms }),
    };

    // Now require the functions module with firebase-admin mocked
    ftest = require('firebase-functions-test')();
    const myFunctions = proxyquire('../index', {
      'firebase-admin': mockAdmin,
    });
    wrapped = ftest.wrap(myFunctions.sendContactEmail);
  });

  after(function () {
    this.timeout(5000);
    ftest.cleanup();
  });

  it('saves contact and returns savedId when SendGrid not configured', async () => {
    const res = await wrapped({ name: 'Alice', email: 'alice@example.com', message: 'Hello' }, { auth: { uid: 'u1' } });
    assert.strictEqual(res.success, true);
    assert.strictEqual(res.savedId, 'mockedId');
    assert.strictEqual(res.emailSent, false);
  });
});
