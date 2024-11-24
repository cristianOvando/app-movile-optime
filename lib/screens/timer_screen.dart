import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
    if (isRunning) {
      _timer.cancel();
    }
    super.dispose();
  }

  void startTimer() {
    setState(() => isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        secondsElapsed++;
      });
    });
  }

  void stopTimer() async {
    if (isRunning) {
      _timer.cancel();
      setState(() => isRunning = false);

      final formattedTime = formatFullTime(secondsElapsed);
      final minutes = (secondsElapsed / 60).floor();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF167BCE),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, size: 60, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  'Has estudiado\n$formattedTime',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await saveStudyDataWithFeedback(1, minutes);
                    resetTimer();
                  },
                  child: const Text(
                    'Aceptar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void resetTimer() {
    setState(() {
      secondsElapsed = 0;
      isRunning = false;
    });
  }

  Future<void> saveStudyDataWithFeedback(int userId, int minutes) async {
    final date = DateTime.now().toIso8601String().split('T')[0];
    final studyData = {
      "user_id": userId,
      "minutes": minutes,
      "date": date,
    };

    String feedbackMessage;
    Icon feedbackIcon;

    try {
      final response = await sendStudyData(studyData);

      if (response.statusCode == 200) {
        feedbackMessage = 'Datos guardados exitosamente.';
        feedbackIcon = const Icon(Icons.check_circle, color: Colors.green, size: 60);
      } else {
        feedbackMessage = 'Error del servidor: ${response.body}';
        feedbackIcon = const Icon(Icons.error, color: Colors.red, size: 60);
      }
    } catch (e) {
      await saveDataLocally(studyData);
      feedbackMessage = 'No se pudo conectar. Datos guardados localmente.';
      feedbackIcon = const Icon(Icons.error, color: Colors.red, size: 60);
    }

    // Mostrar un AlertDialog con el mensaje de feedback
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              feedbackIcon,
              const SizedBox(height: 10),
              Text(
                feedbackMessage,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cerrar',
                  style: TextStyle(color: Color(0xFF167BCE)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<http.Response> sendStudyData(Map<String, dynamic> studyData) async {
    final url = Uri.parse('http://52.72.86.85:5001/api/save');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(studyData),
    );
  }

  Future<void> saveDataLocally(Map<String, dynamic> studyData) async {
    final prefs = await SharedPreferences.getInstance();
    final pendingData = prefs.getStringList('pendingData') ?? [];
    pendingData.add(jsonEncode(studyData));
    await prefs.setStringList('pendingData', pendingData);
  }

  String formatFullTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF167BCE),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: const Text(
            'Temporizador',
            style: TextStyle(
              color: Color(0xFF167BCE),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 180.0,
              lineWidth: 15.0,
              percent: 1.0,
              center: Text(
                formatFullTime(secondsElapsed),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4B97D5),
                ),
              ),
              progressColor: const Color(0xFF4B97D5),
              backgroundColor: const Color(0xFFB5CEE3),
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isRunning ? stopTimer : startTimer,
              style: ElevatedButton.styleFrom(
                backgroundColor: isRunning ? Colors.red : const Color(0xFF167BCE),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                isRunning ? 'Detener' : 'Iniciar',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
