import 'package:flutter/material.dart';

class MfaCodeInput extends StatelessWidget {
  final void Function(String code) onSubmit;
  final bool isLoading;
  final String? errorMessage;

  const MfaCodeInput({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Enter MFA Code',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 200,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '6-digit code',
            ),
            maxLength: 6,
          ),
        ),
        const SizedBox(height: 8),
        if (errorMessage != null)
          Text(errorMessage!, style: const TextStyle(color: Colors.red)),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: isLoading ? null : () => onSubmit(controller.text.trim()),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Verify'),
        ),
      ],
    );
  }
}
