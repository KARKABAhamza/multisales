// Display widgets stubs for demo
import 'package:flutter/material.dart';

class ResponsiveCard extends StatelessWidget {
  final Widget child;
  const ResponsiveCard({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Card(child: child);
  }
}

class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double mobileFontSize;
  final double tabletFontSize;
  final double desktopFontSize;
  const ResponsiveText(this.text, {super.key, this.style, this.mobileFontSize = 16, this.tabletFontSize = 18, this.desktopFontSize = 20});
  @override
  Widget build(BuildContext context) {
    return Text(text, style: style);
  }
}

class ResponsiveNotificationBanner extends StatelessWidget {
  final String message;
  final NotificationType type;
  final bool showAction;
  final String actionLabel;
  final VoidCallback? onAction;
  const ResponsiveNotificationBanner({super.key, required this.message, required this.type, required this.showAction, required this.actionLabel, this.onAction});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.blue,
      child: Text(message),
    );
  }
}

enum NotificationType { info, warning, error }

class ResponsiveStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final String trend;
  final bool isPositiveTrend;
  final VoidCallback onTap;
  const ResponsiveStatsCard({super.key, required this.title, required this.value, required this.subtitle, required this.icon, required this.iconColor, required this.trend, required this.isPositiveTrend, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(value),
      onTap: onTap,
    );
  }
}

class ResponsiveTabs extends StatelessWidget {
  final List<TabData> tabs;
  const ResponsiveTabs({super.key, required this.tabs});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          TabBar(
            tabs: tabs.map((tab) => Tab(text: tab.title, icon: tab.icon)).toList(),
          ),
          SizedBox(
            height: 200,
            child: TabBarView(
              children: tabs.map((tab) => tab.content).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class TabData {
  final String title;
  final Widget icon;
  final Widget content;
  TabData({required this.title, required this.icon, required this.content});
}

class ResponsiveChart extends StatelessWidget {
  final String title;
  final ChartType type;
  final List<ChartData> data;
  const ResponsiveChart({super.key, required this.title, required this.type, required this.data});
  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}

enum ChartType { line, pie, bar }

class ChartData {
  final String label;
  final num value;
  ChartData({required this.label, required this.value});
}

class ResponsiveGrid extends StatelessWidget {
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final List<Widget> children;
  const ResponsiveGrid({super.key, required this.mobileColumns, required this.tabletColumns, required this.desktopColumns, required this.children});
  @override
  Widget build(BuildContext context) {
    return Wrap(children: children);
  }
}

class ResponsiveEmptyState extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String actionLabel;
  const ResponsiveEmptyState({super.key, required this.title, required this.description, required this.icon, required this.actionLabel});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title));
  }
}

class ResponsiveProductCard extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final String? originalPrice;
  final String? imageUrl;
  final String category;
  final double rating;
  final int reviewCount;
  final bool isOnSale;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final VoidCallback onAddToCart;
  final bool isFavorite;
  const ResponsiveProductCard({super.key, required this.name, required this.description, required this.price, this.originalPrice, this.imageUrl, required this.category, required this.rating, required this.reviewCount, required this.isOnSale, required this.onTap, required this.onFavorite, required this.onAddToCart, required this.isFavorite});
  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(title: Text(name), subtitle: Text(description)));
  }
}

class ResponsiveTimeline extends StatelessWidget {
  final List<TimelineItem> items;
  const ResponsiveTimeline({super.key, required this.items});
  @override
  Widget build(BuildContext context) {
    return Column(children: items);
  }
}

class TimelineItem extends StatelessWidget {
  final String title;
  final String description;
  final String timestamp;
  final IconData icon;
  final bool isCompleted;
  const TimelineItem({super.key, required this.title, required this.description, required this.timestamp, required this.icon, required this.isCompleted});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(description),
      trailing: Text(timestamp),
    );
  }
}
