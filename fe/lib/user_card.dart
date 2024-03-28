import 'package:flutter/material.dart';


class UserCard extends StatelessWidget {
  final user;
  const UserCard({
    super.key,
    required this.user
  });

  @override
  Widget build(BuildContext context) {    
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Text("${user.username}"),
                Text("${user.lastName}"),
              ]
            ),
            Text("${user.firstName}"),
            Text("${user.id}"),
          ]
           
        ),
      ),
    );
  }
}