// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../presentation/widgets/sarlau_app_bar.dart';
import '../presentation/widgets/sarlau_footer.dart';
import '../core/providers/contact_provider.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SarlauAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Text('Contact', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            const Text('Adresse: 49 boulevard CHEFCHAOUNI II Ain Sébaâ Casablanca'),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Nom'),
                    onSaved: (v) => name = v ?? '',
                    validator: (v) => v == null || v.isEmpty ? 'Champ requis' : null,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    onSaved: (v) => email = v ?? '',
                    validator: (v) => v == null || !v.contains('@') ? 'Email invalide' : null,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Message'),
                    maxLines: 5,
                    onSaved: (v) => message = v ?? '',
                    validator: (v) => v == null || v.isEmpty ? 'Champ requis' : null,
                  ),
                  const SizedBox(height: 12),
                  Consumer<ContactProvider>(
                    builder: (context, provider, _) => ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                _formKey.currentState?.save();
                                final ok = await context
                                    .read<ContactProvider>()
                                    .submit(name: name, email: email, message: message);
                                if (!mounted) return;
                                if (ok) {
                                  _formKey.currentState?.reset();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Message envoyé')),
                                  );
                                } else if (provider.errorMessage != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(provider.errorMessage!)),
                                  );
                                }
                              }
                            },
                      child: provider.isLoading
                          ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Envoyer'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SarlauFooter(),
          ],
        ),
      ),
    );
  }
}
