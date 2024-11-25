import 'package:flutter/material.dart';
import 'package:optime/screens/schedule_screen.dart';
import '../components/my_app_bar.dart';
import '../components/my_bottom_nav_bar.dart';
import '../screens/calendar_screen.dart';
import '../screens/forum_screen.dart';
import '../screens/chatbot_screen.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> config; 

  const HomeScreen({super.key, required this.config});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const ScheduleScreen(),
      const ForumScreen(),
      ChatbotPage(config: widget.config),
      const CalendarScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: MyBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
