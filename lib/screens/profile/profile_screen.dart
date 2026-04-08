import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/event_model.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/event_service.dart';
import '../../services/user_service.dart';
import '../../widgets/event_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  List<EventModel> _events = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final uid = context.read<AuthService>().currentUser?.uid;
    if (uid == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }

    final user = await context.read<UserService>().getUserProfile(uid);
    final events = await context.read<EventService>().getMyEvents();

    if (mounted) {
      setState(() {
        _user = user;
        _events = events;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(_user?.name ?? 'Unknown user', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(_user?.email ?? ''),
                const SizedBox(height: 24),
                Text('My registered events', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                if (_events.isEmpty)
                  const Text('You have not registered for any events yet.')
                else
                  ..._events.map(
                    (event) => EventCard(
                      event: event,
                      onTap: () {},
                    ),
                  ),
              ],
            ),
    );
  }
}
