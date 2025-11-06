import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'network_service.dart';

class ContactService {
  // Lazy getter to avoid requiring Firebase initialization at construction time (helps in widget tests)
  FirebaseFirestore get _db => FirebaseFirestore.instance;
  final _network = NetworkService();

  Future<void> submitContact({required String name, required String email, required String message}) async {
    // Prefer calling the Cloud Function which saves the contact and sends an email via SendGrid.
    await _network.ensureOnline();

    final callable = FirebaseFunctions.instance.httpsCallable('sendContactEmail');
    try {
      await callable.call(<String, dynamic>{
        'name': name,
        'email': email,
        'message': message,
      }).timeout(const Duration(seconds: 15));
    } on FirebaseFunctionsException catch (e) {
      // Fallback: if function not deployed, save to Firestore to avoid losing the message
      if (e.code == 'unavailable' || e.code == 'not-found') {
        final data = <String, dynamic>{
          'name': name,
          'email': email,
          'message': message,
          'createdAt': FieldValue.serverTimestamp(),
          'status': 'new',
          'source': 'web-fallback',
        };
        await _db.collection('contacts').add(data).timeout(const Duration(seconds: 15));
      } else {
        rethrow;
      }
    }
  }
}
