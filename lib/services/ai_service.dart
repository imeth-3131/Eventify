import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/config/app_config.dart';

class AiService {
  Future<String> sendMessage(String message) async {
    final uri = Uri.parse('${AppConfig.aiProxyBaseUrl}/ai/chat');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('AI request failed with ${response.statusCode}.');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return (json['reply'] ?? '').toString();
  }
}
