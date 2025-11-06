import 'package:flutter/material.dart';

class MainFooter extends StatelessWidget {
  const MainFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      color: Colors.blueGrey[50],
      child: Center(
        child: Text('© 2025 SkyConnect Maroc. Tous droits réservés.'),
      ),
    );
  }
}
