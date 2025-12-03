import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

class AdminClaimsPage extends StatefulWidget {
  const AdminClaimsPage({super.key});

  @override
  State<AdminClaimsPage> createState() => _AdminClaimsPageState();
}

class _AdminClaimsPageState extends State<AdminClaimsPage> {
  final _formKey = GlobalKey<FormState>();
  final _uidCtrl = TextEditingController();
  String? _role; // 'admin' | 'manager' | 'user'
  bool _adminFlag = false;
  bool _managerFlag = false;
  bool _isLoading = false;
  String? _error;
  String? _success;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _error = null; _success = null; });
    try {
      final callable = FirebaseFunctions.instance.httpsCallable('setUserClaims');
      final res = await callable.call({
        'uid': _uidCtrl.text.trim(),
        'role': _role,
        'roles': { 'admin': _adminFlag, 'manager': _managerFlag },
      });
      if (res.data is Map && res.data['ok'] == true) {
        setState(() { _success = 'Claims updated'; });
      } else {
        setState(() { _error = 'Operation failed'; });
      }
    } catch (e) {
      setState(() { _error = e.toString(); });
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin: Set User Claims')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              controller: _uidCtrl,
              decoration: const InputDecoration(labelText: 'User UID'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'UID required' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _role,
              decoration: const InputDecoration(labelText: 'Primary Role'),
              items: const [
                DropdownMenuItem(value: 'admin', child: Text('admin')),
                DropdownMenuItem(value: 'manager', child: Text('manager')),
                DropdownMenuItem(value: 'user', child: Text('user')),
              ],
              onChanged: (v) => setState(() { _role = v; }),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _adminFlag,
              onChanged: (v) => setState(() { _adminFlag = v; }),
              title: const Text('roles.admin'),
            ),
            SwitchListTile(
              value: _managerFlag,
              onChanged: (v) => setState(() { _managerFlag = v; }),
              title: const Text('roles.manager'),
            ),
            const SizedBox(height: 12),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_success != null) Text(_success!, style: const TextStyle(color: Colors.green)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              child: _isLoading ? const CircularProgressIndicator() : const Text('Update Claims'),
            ),
          ]),
        ),
      ),
    );
  }
}