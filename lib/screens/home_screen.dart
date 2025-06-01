import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<FlSpot> _generateMockGlucoseData() {
    final random = Random();
    return List.generate(7, (i) {
      final time = i.toDouble();
      final glucose = 80 + random.nextInt(100); // entre 80 e 180
      return FlSpot(time, glucose.toDouble());
    });
  }

  @override
  Widget build(BuildContext context) {
    final mockData = _generateMockGlucoseData();

    return Scaffold(
      appBar: AppBar(title: const Text('Resumo do Dia')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Glicemia - Últimas medições',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 6,
                  minY: 70,
                  maxY: 200,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, interval: 20),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, _) => Text('Dia ${value.toInt() + 1}'),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: mockData,
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _SummaryCard(
                  icon: Icons.restaurant,
                  label: 'Refeições',
                  count: 3,
                  color: Colors.orange,
                ),
                _SummaryCard(
                  icon: Icons.monitor_heart,
                  label: 'Glicemias',
                  count: 5,
                  color: Colors.red,
                ),
                _SummaryCard(
                  icon: Icons.directions_run,
                  label: 'Atividades',
                  count: 2,
                  color: Colors.blue,
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dados atualizados (fictício)')),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Atualizar'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
        child: Column(
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}
