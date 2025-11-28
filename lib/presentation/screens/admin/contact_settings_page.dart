import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Admin screen to edit contact settings. No dependency on ContactSection.
import '../../../core/providers/contact_provider.dart';
import '../../../core/services/auth_service.dart';

class ContactSettingsPage extends StatefulWidget {
  const ContactSettingsPage({super.key});

  @override
  State<ContactSettingsPage> createState() => _ContactSettingsPageState();
}

class _ContactSettingsPageProtected extends StatelessWidget {
  final Widget child;
  const _ContactSettingsPageProtected({required this.child});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return FutureBuilder<bool>(
      future: authService.hasRole('admin'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Contact settings')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData && snapshot.data == true) {
          return child;
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Access denied')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text('You do not have permission to access this page.'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Go back'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ContactSettingsPageState extends State<ContactSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _hoursCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // we'll populate fields from provider in didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = context.read<ContactProvider>();
    final info = provider.info;
    _phoneCtrl.text = info.phone;
    _emailCtrl.text = info.email;
    _addressCtrl.text = info.address;
    _hoursCtrl.text = info.hours;
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _hoursCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<ContactProvider>();
    final info = ContactInfo(
      phone: _phoneCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      hours: _hoursCtrl.text.trim(),
    );
    final ok = await provider.saveContactInfo(info: info);
    if (ok) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Paramètres contact enregistrés')));
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Échec de l’enregistrement')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ContactSettingsPageProtected(
      child: Scaffold(
        appBar: AppBar(title: const Text('Contact settings')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: 'Phone')),
                const SizedBox(height: 8),
                TextFormField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
                const SizedBox(height: 8),
                TextFormField(controller: _addressCtrl, decoration: const InputDecoration(labelText: 'Address'), maxLines: 2),
                const SizedBox(height: 8),
                TextFormField(controller: _hoursCtrl, decoration: const InputDecoration(labelText: 'Hours')),
                const SizedBox(height: 16),
                ElevatedButton.icon(onPressed: _save, icon: const Icon(Icons.save), label: const Text('Save')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
