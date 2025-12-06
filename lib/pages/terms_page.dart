import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(children: const [
          Text('By using this website, you agree to the terms and acceptable use policies.'),
          SizedBox(height: 12),
          Text('All content is provided as-is without warranties.'),
        ]),
      ),
    );
  }
}