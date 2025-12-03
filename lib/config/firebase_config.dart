import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

/// Initialize Firebase using the generated Firebase options.
/// If you need to override the Realtime Database URL, pass `databaseUrl`.
Future<FirebaseApp> initFirebase({String? databaseUrl}) async {
  FirebaseOptions options = DefaultFirebaseOptions.currentPlatform;

  if (databaseUrl != null && databaseUrl.isNotEmpty) {
    // Build a copy of the existing options but with a custom databaseURL.
    options = FirebaseOptions(
      apiKey: options.apiKey,
      appId: options.appId,
      messagingSenderId: options.messagingSenderId,
      projectId: options.projectId,
      authDomain: options.authDomain,
      storageBucket: options.storageBucket,
      measurementId: options.measurementId,
      databaseURL: databaseUrl,
    );
  }

  return Firebase.initializeApp(options: options);
}
