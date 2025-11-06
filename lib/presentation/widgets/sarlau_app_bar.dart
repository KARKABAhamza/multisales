import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../l10n/app_localizations.dart';
import '../../design/design_tokens.dart';

class SarlauAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showActions;
  const SarlauAppBar({super.key, this.showActions = true});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          leading: const SizedBox(width: 8),
          leadingWidth: 8,
          titleSpacing: DesignTokens.spacing,
          title: InkWell(
            onTap: () => context.go('/'),
            child: Row(
              children: [
                // Replace with your branded asset if desired
                Image.asset(
                  'assets/images/multisales_logo.jpg',
                  height: 32,
                  errorBuilder: (_, __, ___) => Icon(Icons.business, size: 32, color: onPrimary),
                ),
                const SizedBox(width: 12),
                Text(t.brandName, style: TextStyle(letterSpacing: 1.2, color: onPrimary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          actions: showActions
              ? [
                  _NavBtn(label: t.menuHome, route: '/', color: onPrimary),
                  _NavBtn(label: t.menuExpertise, route: '/expertise', color: onPrimary),
                  _NavBtn(label: t.menuServices, route: '/services', color: onPrimary),
                  _NavBtn(label: t.menuContact, route: '/contact', color: onPrimary),
                  const SizedBox(width: 12),
                ]
              : null,
          // Subtle bottom divider using flexibleSpace
          flexibleSpace: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 1,
              color: Colors.black.withValues(alpha: 0.08),
            ),
          ),
        ),
        // Offline banner (compact)
        StreamBuilder<List<ConnectivityResult>>(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, snapshot) {
            final results = snapshot.data;
            final online = results == null
                ? true
                : results.contains(ConnectivityResult.mobile) ||
                    results.contains(ConnectivityResult.wifi) ||
                    results.contains(ConnectivityResult.ethernet) ||
                    results.contains(ConnectivityResult.vpn);
            if (online) return const SizedBox.shrink();
            return Container(
              width: double.infinity,
              color: Colors.red.shade600,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              child: Text(
                t.offlineNotice,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _NavBtn extends StatelessWidget {
  final String label;
  final String route;
  final Color color;
  const _NavBtn({required this.label, required this.route, required this.color});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.go(route),
      child: Text(label, style: TextStyle(color: color)),
    );
  }
}
