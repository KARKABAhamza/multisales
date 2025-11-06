class ContactService {
  // Simule l'envoi d'un message de contact (à remplacer par Firestore ou API)
  Future<void> sendContactMessage({
    required String name,
    required String email,
    required String message,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    // Ici, on simulerait l'envoi à Firestore ou par email
  }
}
