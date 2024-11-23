import 'package:flutter/material.dart';
import 'package:optime/screens/schedule_screen.dart';
import '../components/my_app_bar.dart';
import '../components/my_bottom_nav_bar.dart';
import '../screens/calendar_screen.dart';
import '../screens/forum_screen.dart';
import '../screens/chatbot_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ScheduleScreen(),
    const ForumScreen(),
    const ChatbotScreen(),
    const CalendarScreen(),
  ];

  // Método para manejar el cambio de pestañas
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(), // Usa el componente personalizado
      body: IndexedStack(
        index: _selectedIndex, // Muestra la pantalla correspondiente
        children: _screens,
      ),
      bottomNavigationBar: MyBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
