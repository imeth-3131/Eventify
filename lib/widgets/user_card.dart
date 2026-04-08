import 'package:flutter/material.dart';

import '../models/user_model.dart';

class UserCard extends StatelessWidget {
  final UserModel user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(user.name),
        subtitle: Text('${user.email}\nBatch: ${user.batch} | University: ${user.university}'),
        isThreeLine: true,
      ),
    );
  }
}
