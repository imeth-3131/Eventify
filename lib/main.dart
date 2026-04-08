import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/firebase_options.dart';
import 'core/theme/theme_controller.dart';
import 'services/auth_service.dart';
import 'services/event_service.dart';
import 'services/user_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final themeController = ThemeController();
  await themeController.loadTheme();

  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeController>.value(value: themeController),
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<UserService>(create: (_) => UserService()),
        Provider<EventService>(create: (_) => EventService()),
        Provider<NotificationService>.value(value: notificationService),
      ],
      child: const EventifyApp(),
    ),
  );
}
