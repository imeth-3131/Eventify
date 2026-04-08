import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'screens/admin/admin_panel_screen.dart';
import 'screens/admin/registered_users_screen.dart';
import 'screens/ai/ai_chat_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/events/event_details_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/settings/settings_screen.dart';

class EventifyApp extends StatelessWidget {
  const EventifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return MaterialApp(
      title: 'Eventify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.themeMode,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.signup: (_) => const SignUpScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
        AppRoutes.settings: (_) => const SettingsScreen(),
        AppRoutes.adminPanel: (_) => const AdminPanelScreen(),
        AppRoutes.aiChat: (_) => const AiChatScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.eventDetails) {
          return MaterialPageRoute(
            builder: (_) => EventDetailsScreen(event: settings.arguments!),
          );
        }
        if (settings.name == AppRoutes.registeredUsers) {
          final args = settings.arguments! as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => RegisteredUsersScreen(
              eventId: args['eventId'] as String,
              eventTitle: args['eventTitle'] as String,
            ),
          );
        }
        return null;
      },
    );
  }
}
