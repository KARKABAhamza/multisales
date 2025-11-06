// Stubs for Enhanced UI components
import 'package:flutter/material.dart';
import 'enhanced_dashboard_widgets.dart';

class EnhancedNavigationDrawer extends StatelessWidget {
  final String currentRoute;
  final Function(String) onItemTap;
  final List<NavigationItem> items;
  const EnhancedNavigationDrawer({required this.currentRoute, required this.onItemTap, required this.items, super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: items.map((item) {
          return ListTile(
            leading: Icon(item.icon),
            title: Text(item.title),
            subtitle: Text(item.subtitle),
            selected: item.route == currentRoute,
            onTap: () => onItemTap(item.route),
          );
        }).toList(),
      ),
    );
  }
}

class EnhancedSearchBar extends StatelessWidget {
  final String hintText;
  final Function(String) onSearch;
  final VoidCallback onVoiceSearch;
  const EnhancedSearchBar({required this.hintText, required this.onSearch, required this.onVoiceSearch, super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hintText,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.search),
              ),
              onSubmitted: onSearch,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: onVoiceSearch,
          ),
        ],
      ),
    );
  }
}

class EnhancedBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavigationItem> items;
  const EnhancedBottomNavigationBar({required this.currentIndex, required this.onTap, required this.items, super.key});
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items.map((item) => BottomNavigationBarItem(
        icon: Icon(item.icon),
        label: item.label,
      )).toList(),
      type: BottomNavigationBarType.fixed,
    );
  }
}
