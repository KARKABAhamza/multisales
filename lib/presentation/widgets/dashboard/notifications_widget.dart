import 'package:flutter/material.dart';

class NotificationsWidget extends StatelessWidget {
  final List<String> notifications;
  const NotificationsWidget({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) => ListTile(
          leading: const Icon(Icons.notifications),
          title: Text(notifications[i]),
        ),
      ),
    );
  }
}
