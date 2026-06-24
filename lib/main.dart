import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/registration_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation.dart';

void main() {
  runApp(const MoodScapeApp());
}

class MoodScapeApp extends StatelessWidget {
  const MoodScapeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoodScape',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/main': (context) => const MainNavigation(),
      },
    );
  }
}