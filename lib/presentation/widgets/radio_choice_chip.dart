import 'package:flutter/material.dart';

/// A reusable, accessible radio-like choice chip.
/// - Shows a checked/unchecked radio icon and a label.
/// - Calls [onTap] when pressed.
class RadioChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;

  const RadioChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: padding,
          decoration: BoxDecoration(
      // Use withValues instead of deprecated withOpacity
      color: selected
        ? primary.withValues(alpha: 0.12)
        : Colors.transparent,
            border: Border.all(color: selected ? primary : Colors.grey.shade400),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 18,
                color: selected ? primary : Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected ? primary : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
