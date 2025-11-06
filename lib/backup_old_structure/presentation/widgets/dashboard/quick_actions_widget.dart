import 'package:flutter/material.dart';

class QuickActionsWidget extends StatelessWidget {
  final List<QuickAction> actions;
  const QuickActionsWidget({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: actions
          .map((action) => IconButton(
                icon: Icon(action.icon),
                tooltip: action.label,
                onPressed: action.onPressed,
              ))
          .toList(),
    );
  }
}

class QuickAction {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  QuickAction(
      {required this.icon, required this.label, required this.onPressed});
}
