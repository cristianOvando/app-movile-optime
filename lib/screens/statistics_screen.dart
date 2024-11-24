import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<FlSpot> timeSeriesData = [];
  String predictionText = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStatistics();
  }

  Future<void> fetchStatistics() async {
    setState(() => isLoading = true);
    try {
      final url = Uri.parse('http://52.72.86.85:5001/api/predict');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"user_id": 1}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List<dynamic> history = data['history'];
        double prediction = data['prediction'];

        setState(() {
          timeSeriesData = history
              .map((entry) =>
                  FlSpot(entry['day'].toDouble(), entry['hours'].toDouble()))
              .toList();
          predictionText = 'Tiempo mañana: Se predice que estudiarás ${prediction.toStringAsFixed(1)} horas.';
          isLoading = false;
        });
      } else {
        setState(() {
          predictionText = 'Error al obtener la predicción.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        predictionText = 'Error de conexión: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minería de Datos'),
        backgroundColor: const Color(0xFF167BCE),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Horas Estudiadas',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF167BCE),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${value.toInt()}h',
                                  style: const TextStyle(
                                    color: Color(0xFF4B97D5),
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.left,
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  'Día ${value.toInt()}',
                                  style: const TextStyle(
                                    color: Color(0xFF4B97D5),
                                    fontSize: 12,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: const Color(0xFFB5CEE3),
                            width: 1,
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: timeSeriesData,
                            isCurved: true,
                            gradient: LinearGradient(
                              colors: const [
                                Color(0xFF167BCE),
                                Color(0xFF4B97D5),
                                Color(0xFFB5CEE3),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            barWidth: 4,
                            isStrokeCapRound: true,
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFB5CEE3).withOpacity(0.3),
                                  const Color(0xFF4B97D5).withOpacity(0.1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    predictionText,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B97D5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
    );
  }
}
