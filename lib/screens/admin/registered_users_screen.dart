import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../services/event_service.dart';
import '../../services/user_service.dart';
import '../../widgets/user_card.dart';

class RegisteredUsersScreen extends StatefulWidget {
  final String eventId;
  final String eventTitle;

  const RegisteredUsersScreen({
    super.key,
    required this.eventId,
    required this.eventTitle,
  });

  @override
  State<RegisteredUsersScreen> createState() => _RegisteredUsersScreenState();
}

class _RegisteredUsersScreenState extends State<RegisteredUsersScreen> {
  List<UserModel> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final eventService = context.read<EventService>();
    final userService = context.read<UserService>();

    final userIds = await eventService.getRegisteredUserIdsForEvent(widget.eventId);
    final users = await userService.getUsersByIds(userIds);

    if (mounted) {
      setState(() {
        _users = users;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrations for ${widget.eventTitle}')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? const Center(child: Text('No users registered yet.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _users.length,
                  itemBuilder: (context, index) => UserCard(user: _users[index]),
                ),
    );
  }
}
