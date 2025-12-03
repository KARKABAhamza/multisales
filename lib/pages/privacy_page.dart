import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(children: const [
          Text('This website collects minimal personal data necessary to provide services.'),
          SizedBox(height: 12),
          Text('We do not sell your data. Contact support to request deletion.'),
        ]),
      ),
    );
  }
}