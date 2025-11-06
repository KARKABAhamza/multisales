import 'package:flutter/material.dart';

class LegalPage extends StatelessWidget {
  const LegalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mentions légales')),
      body: Center(child: Text('Mentions légales et CGU ici.')),
    );
  }
}
