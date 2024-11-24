import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer;
  bool isRunning = false;
  int secondsElapsed = 0;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    if (!isRunning) {
      setState(() => isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          secondsElapsed++;
        });
      });
    }
  }

  void pauseTimer() {
    if (isRunning) {
      setState(() => isRunning = false);
      _timer.cancel();
    }
  }

  void resetTimer() {
    setState(() {
      secondsElapsed = 0;
      isRunning = false;
    });
    _timer.cancel();
  }

  void finishTimer() async {
    pauseTimer();
    int minutes = (secondsElapsed / 60).floor();
    DateTime now = DateTime.now();
    String formattedDate = now.toIso8601String().split('T')[0];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tiempo de estudio completado'),
          content: Text('Has estudiado $minutes minutos.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                sendStudyData(1, minutes, formattedDate); 
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> sendStudyData(int userId, int minutes, String date) async {
    try {
      final url = Uri.parse('http://52.72.86.85:5001/api/save');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user_id": userId,
          "minutes": minutes,
          "date": date,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tiempo guardado exitosamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temporizador'),
        backgroundColor: const Color.fromARGB(255, 22, 123, 206),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formatTime(secondsElapsed),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: startTimer,
                  child: const Text('Iniciar'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: pauseTimer,
                  child: const Text('Pausar'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: resetTimer,
                  child: const Text('Reiniciar'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: finishTimer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Terminar'),
            ),
          ],
        ),
      ),
    );
  }
}
