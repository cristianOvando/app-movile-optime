import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:optime/screens/create_contact_screen.dart';
import 'package:optime/screens/home_screen.dart';
import 'package:optime/screens/login_screen.dart';
import 'package:optime/screens/register_user_screen.dart.dart';
import 'package:optime/screens/schedule_screen.dart';
import 'package:optime/screens/forum_screen.dart';
import 'package:optime/screens/chatbot_screen.dart';
import 'package:optime/screens/calendar_screen.dart';
import 'package:optime/screens/settings_screen.dart';
import 'package:optime/screens/statistics_screen.dart';
import 'package:optime/screens/timer_screen.dart';
import 'package:optime/screens/validate_code_screen.dart';


Map<String, dynamic> config = {};

Future<void> loadConfig() async {
  try {
    final String response = await rootBundle.loadString('lib/assets/config.json');
    config = json.decode(response);
    if (config['API_KEY'] == null || config['API_KEY'].isEmpty) {
      throw Exception("Clave API no encontrada en config.json");
    }
    print("Configuración cargada: $config");
  } catch (e) {
    print("Error al cargar la configuración: $e");
    config = {}; 
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await loadConfig();
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
        '/Login': (context) => const LoginScreen(),
        '/Create-contact': (context) => const CreateContactScreen(),
        '/Validate-code': (context) => const ValidateCodeScreen(),
        '/Register-user': (context) => const RegisterUserScreen(),
        '/': (context) => HomeScreen(config: config),
        '/Timer': (context) => const TimerScreen(),
        '/Statistics': (context) =>  StatisticsScreen(),
        '/Settings': (context) => const SettingsScreen(),
        '/Schedule': (context) => const ScheduleScreen(),
        '/Forum': (context) => const ForumScreen(),
        '/chatbot': (context) => ChatbotPage(config: config),
        '/Calendar': (context) => const CalendarScreen(),
      },
    );
  }
}
