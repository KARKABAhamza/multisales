import 'package:flutter/material.dart';

class DashboardWidgets extends StatelessWidget {
  final List<Widget> widgets;
  const DashboardWidgets({super.key, required this.widgets});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.3,
      children: widgets,
    );
  }
}
