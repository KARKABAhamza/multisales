// Stub for EnhancedButton
import 'package:flutter/material.dart';

class EnhancedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final ButtonStyle? style;
  const EnhancedButton({required this.onPressed, required this.child, this.style, super.key});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: child,
    );
  }
}
