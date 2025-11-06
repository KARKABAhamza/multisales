import 'package:flutter/material.dart';

class AccountHomeContent extends StatelessWidget {
  const AccountHomeContent({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Bienvenue dans votre espace client'));
  }
// Removed: Account content widgets. File left as stub.
}

class AccountDocumentsContent extends StatelessWidget {
  const AccountDocumentsContent({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Mes Documents'));
  }
}

class AccountCommunicationsContent extends StatelessWidget {
  const AccountCommunicationsContent({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Mes Communications'));
  }
}

class AccountContractsContent extends StatelessWidget {
  const AccountContractsContent({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Mes Contrats'));
  }
}
