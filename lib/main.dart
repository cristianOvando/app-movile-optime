
import 'package:flutter/material.dart';
import 'package:optime/screens/create_contact_screen.dart';
import 'package:optime/screens/login_screen.dart';
import 'package:optime/screens/register_user_screen.dart.dart';
import 'package:optime/screens/home_screen.dart';
import 'package:optime/screens/schedule_screen.dart';
import 'package:optime/screens/forum_screen.dart';
import 'package:optime/screens/chatbot_screen.dart';
import 'package:optime/screens/calendar_screen.dart';
import 'package:optime/screens/settings_screen.dart';
import 'package:optime/screens/timer_screen.dart';
import 'package:optime/screens/validate_code_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OPTIME',
      debugShowCheckedModeBanner: false, 
      initialRoute: '/',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/create-contact': (context) => const CreateContactScreen(),
        '/validate-code': (context) => const ValidateCodeScreen(),
        '/register-user': (context) => const RegisterUserScreen(),
        '/': (context) => const HomeScreen(),
        '/Timer': (context) => const TimerScreen(),
        '/Settings': (context) => const SettingsScreen(),
        '/schedule': (context) => const ScheduleScreen(),
        '/forum': (context) => const ForumScreen(),
        '/chatbot': (context) => const ChatbotScreen(),
        '/calendar': (context) => const CalendarScreen(),
      },
    );
  }
}
