
// ignore_for_file: deprecated_member_use

// Stubs for EnhancedDashboard widgets
import 'package:flutter/material.dart';

class BottomNavigationItem {
  final String label;
  final IconData icon;
  final String route;
  const BottomNavigationItem({required this.label, required this.icon, required this.route});
}

class NavigationItem {
  final String title;
  final String route;
  final IconData icon;
  final String subtitle;
  const NavigationItem({required this.title, required this.route, required this.icon, required this.subtitle});
}

class EnhancedCard extends StatelessWidget {
  final Widget child;
  const EnhancedCard({required this.child, super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: child,
    );
  }
}

class EnhancedMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;
  final bool isPositiveTrend;
  final VoidCallback? onTap;
  const EnhancedMetricCard({required this.title, required this.value, required this.icon, required this.color, required this.trend, required this.isPositiveTrend, this.onTap, super.key});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: color.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 28),
                  const SizedBox(width: 12),
                  Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                ],
              ),
              const SizedBox(height: 8),
              Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 8),
              Text(trend, style: TextStyle(color: isPositiveTrend ? Colors.green : Colors.red, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
