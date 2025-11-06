import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/contact_provider.dart';
import '../../core/localization/app_localizations.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _message = '';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return ChangeNotifierProvider(
      create: (_) => ContactProvider(),
      child: Consumer<ContactProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(localizations?.support ?? 'Contact'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: localizations?.firstName ?? 'Nom'),
                      onSaved: (value) => _name = value ?? '',
                      validator: (value) => (value == null || value.isEmpty) ? 'Champ requis' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(labelText: localizations?.email ?? 'Email'),
                      onSaved: (value) => _email = value ?? '',
                      validator: (value) => (value == null || value.isEmpty) ? 'Champ requis' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Message'),
                      maxLines: 5,
                      onSaved: (value) => _message = value ?? '',
                      validator: (value) => (value == null || value.isEmpty) ? 'Champ requis' : null,
                    ),
                    const SizedBox(height: 24),
                    if (provider.isLoading)
                      const CircularProgressIndicator(),
                    if (provider.errorMessage != null)
                      Text(provider.errorMessage!, style: const TextStyle(color: Colors.red)),
                    if (provider.success)
                      const Text('Message envoyé avec succès !', style: TextStyle(color: Colors.green)),
                    if (!provider.isLoading && !provider.success)
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState?.save();
                            provider.sendContactMessage(_name, _email, _message);
                          }
                        },
                        child: Text(localizations?.sendMessage ?? 'Envoyer'),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
