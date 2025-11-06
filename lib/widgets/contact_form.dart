import 'package:flutter/material.dart';

class ContactForm extends StatelessWidget {
  const ContactForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(decoration: InputDecoration(labelText: 'Nom')),
        TextField(decoration: InputDecoration(labelText: 'Email')),
        TextField(decoration: InputDecoration(labelText: 'Message'), maxLines: 3),
        SizedBox(height: 12),
        ElevatedButton(onPressed: () {}, child: Text('Envoyer')),
      ],
    );
  }
}
