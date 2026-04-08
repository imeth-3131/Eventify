import 'package:flutter/material.dart';

import '../../services/ai_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _messageController = TextEditingController();
  final _aiService = AiService();
  String _response = '';
  bool _loading = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _loading = true;
      _response = 'Thinking...';
    });

    try {
      final reply = await _aiService.sendMessage(message);
      if (mounted) {
        setState(() => _response = reply);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _response = 'Failed to connect: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Chat')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.outline),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(child: Text(_response.isEmpty ? 'Ask something...' : _response)),
              ),
            ),
            const SizedBox(height: 12),
            CustomTextField(controller: _messageController, label: 'Your message'),
            const SizedBox(height: 12),
            PrimaryButton(text: 'Send', onPressed: _send, loading: _loading),
          ],
        ),
      ),
    );
  }
}
