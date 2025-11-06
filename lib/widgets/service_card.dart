import 'package:flutter/material.dart';
import '../models/service.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  const ServiceCard({required this.service, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(service.title),
        subtitle: Text(service.desc),
        leading: Icon(Icons.build),
        onTap: () => Navigator.of(context).pushNamed('/services/${service.id}'),
      ),
    );
  }
}
