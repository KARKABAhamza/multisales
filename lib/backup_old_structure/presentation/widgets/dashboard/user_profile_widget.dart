import 'package:flutter/material.dart';

class UserProfileWidget extends StatelessWidget {
  final String? name;
  final String? email;
  final String? avatarUrl;
  const UserProfileWidget({
    super.key,
    this.name,
    this.email,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
          child: avatarUrl == null ? const Icon(Icons.person, size: 32) : null,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (name != null)
              Text(name!, style: Theme.of(context).textTheme.titleMedium),
            if (email != null)
              Text(email!, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}
