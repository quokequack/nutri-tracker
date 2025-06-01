import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resumo do Dia')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('glicemias')
            .orderBy('horario')
            .limit(7)
            .snapshots(),
        builder: (context, glicemiaSnapshot) {
          if (glicemiaSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!glicemiaSnapshot.hasData || glicemiaSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Sem dados de glicemia.'));
          }

          final glicemiaDocs = glicemiaSnapshot.data!.docs;

          final List<FlSpot> glucoseSpots = [];
          for (int i = 0; i < glicemiaDocs.length; i++) {
            final doc = glicemiaDocs[i];
            final valor = double.tryParse(doc['valor'].toString()) ?? 0;
            glucoseSpots.add(FlSpot(i.toDouble(), valor));
          }

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('refeicoes').snapshots(),
            builder: (context, refeicoesSnapshot) {
              final refeicoesCount = refeicoesSnapshot.hasData ? refeicoesSnapshot.data!.docs.length : 0;

              return Padding(
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
                                getTitlesWidget: (value, _) {
                                  if (value.toInt() < glicemiaDocs.length) {
                                    final horario = glicemiaDocs[value.toInt()]['horario'];
                                    return Text(horario, style: const TextStyle(fontSize: 10));
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: glucoseSpots,
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
                      children: [
                        _SummaryCard(
                          icon: Icons.restaurant,
                          label: 'Refeições',
                          count: refeicoesCount,
                          color: Colors.orange,
                        ),
                        _SummaryCard(
                          icon: Icons.monitor_heart,
                          label: 'Glicemias',
                          count: glicemiaDocs.length,
                          color: Colors.red,
                        ),
                        const _SummaryCard(
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
                          const SnackBar(content: Text('Dados atualizados')),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Atualizar'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
                  ],
                ),
              );
            },
          );
        },
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
