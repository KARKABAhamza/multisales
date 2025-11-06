// Custom widgets stubs for demo
import 'package:flutter/material.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? maxWidth;
  const ResponsiveContainer({super.key, required this.child, this.padding, this.maxWidth});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      constraints: maxWidth != null ? BoxConstraints(maxWidth: maxWidth!) : null,
      child: child,
    );
  }
}

class ResponsiveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  const ResponsiveButton({super.key, required this.onPressed, required this.child});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: child);
  }
}

class BreathingWidget extends StatelessWidget {
  final Widget child;
  const BreathingWidget({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  const ResponsiveAppBar({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return AppBar(title: title);
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ResponsiveFormBuilder extends StatelessWidget {
  final bool isLoading;
  final String submitButtonText;
  final void Function(Map<String, dynamic>) onSubmit;
  final List<FormFieldConfig> fields;
  const ResponsiveFormBuilder({super.key, required this.isLoading, required this.submitButtonText, required this.onSubmit, required this.fields});
  @override
  Widget build(BuildContext context) {
    return Column(children: fields);
  }
}

class FormFieldConfig extends StatelessWidget {
  final String fieldKey;
  final String? label;
  final String? hintText;
  final FormFieldType type;
  final Widget? prefixIcon;
  final List<DropdownOption>? options;
  final String? Function(String?)? validator;
  const FormFieldConfig({super.key, required this.fieldKey, this.label, this.hintText, required this.type, this.prefixIcon, this.options, this.validator});
  @override
  Widget build(BuildContext context) {
    return Text(label ?? fieldKey);
  }
}

enum FormFieldType { text, email, dropdown, date, multiline, checkbox }

class DropdownOption {
  final String label;
  final String value;
  DropdownOption({required this.label, required this.value});
}
