import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../services/event_service.dart';
import '../../services/user_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/event_card.dart';
import '../../widgets/primary_button.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  int? _studentCount;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchStudentCount();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _fetchStudentCount() async {
    final count = await context.read<UserService>().getStudentCount();
    if (mounted) setState(() => _studentCount = count);
  }

  Future<void> _addEvent() async {
    final title = _titleController.text.trim();
    final date = _dateController.text.trim();
    final location = _locationController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill title and date.')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await context.read<EventService>().addEvent(
            title: title,
            date: date,
            location: location,
            description: description,
          );
      _titleController.clear();
      _dateController.clear();
      _locationController.clear();
      _descriptionController.clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event added.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add event: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventService = context.read<EventService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Admin panel')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Registered students: ${_studentCount ?? '...'}'),
          const SizedBox(height: 16),
          CustomTextField(controller: _titleController, label: 'Event title'),
          const SizedBox(height: 12),
          CustomTextField(controller: _dateController, label: 'Event date'),
          const SizedBox(height: 12),
          CustomTextField(controller: _locationController, label: 'Event location'),
          const SizedBox(height: 12),
          CustomTextField(controller: _descriptionController, label: 'Event description', maxLines: 4),
          const SizedBox(height: 16),
          PrimaryButton(text: 'Add event', onPressed: _addEvent, loading: _loading),
          const SizedBox(height: 24),
          Text('Events', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          StreamBuilder(
            stream: eventService.streamEvents(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text('Failed to load events: ${snapshot.error}');
              }
              final events = snapshot.data ?? [];
              return Column(
                children: events
                    .map(
                      (event) => EventCard(
                        event: event,
                        isAdmin: true,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.registeredUsers,
                          arguments: {
                            'eventId': event.id,
                            'eventTitle': event.title,
                          },
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
