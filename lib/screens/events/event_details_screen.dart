import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/event_model.dart';
import '../../services/event_service.dart';
import '../../widgets/primary_button.dart';

class EventDetailsScreen extends StatefulWidget {
  final Object event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool _loading = false;
  bool _registered = false;

  late final EventModel event = widget.event as EventModel;

  @override
  void initState() {
    super.initState();
    _loadRegistrationStatus();
  }

  Future<void> _loadRegistrationStatus() async {
    final registered = await context.read<EventService>().isUserRegistered(event.id);
    if (mounted) setState(() => _registered = registered);
  }

  Future<void> _register() async {
    setState(() => _loading = true);
    try {
      await context.read<EventService>().registerForEvent(event.id);
      if (!mounted) return;
      setState(() => _registered = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registered successfully.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Date: ${event.date}'),
            const SizedBox(height: 4),
            Text('Location: ${event.location}'),
            const SizedBox(height: 16),
            Text(event.description),
            const Spacer(),
            PrimaryButton(
              text: _registered ? 'Registered' : 'Register for event',
              onPressed: _registered ? null : _register,
              loading: _loading,
            ),
          ],
        ),
      ),
    );
  }
}
