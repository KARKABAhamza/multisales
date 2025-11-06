import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('SkyConnect Maroc'),
      actions: [
        TextButton(onPressed: () => context.go('/'), child: Text('Accueil')),
        TextButton(onPressed: () => context.go('/expertise'), child: Text('Nos Métiers')),
        TextButton(onPressed: () => context.go('/services'), child: Text('Services')),
        TextButton(onPressed: () => context.go('/a-propos'), child: Text('À propos')),
        TextButton(onPressed: () => context.go('/contact'), child: Text('Contact')),
        TextButton(onPressed: () => context.go('/legal'), child: Text('Mentions légales')),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
