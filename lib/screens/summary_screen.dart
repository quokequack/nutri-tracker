import 'package:flutter/material.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  final List<Map<String, String>> summaryData = const [
    {"day": "Segunda", "glucose": "110", "meals": "3", "activities": "1"},
    {"day": "Terça", "glucose": "105", "meals": "3", "activities": "0"},
    {"day": "Quarta", "glucose": "115", "meals": "4", "activities": "2"},
    {"day": "Quinta", "glucose": "100", "meals": "3", "activities": "1"},
    {"day": "Sexta", "glucose": "108", "meals": "3", "activities": "1"},
    {"day": "Sábado", "glucose": "112", "meals": "3", "activities": "2"},
    {"day": "Domingo", "glucose": "109", "meals": "2", "activities": "0"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo Semanal'),
      ),
      body: ListView.builder(
        itemCount: summaryData.length,
        itemBuilder: (context, index) {
          final daySummary = summaryData[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(daySummary["day"] ?? ''),
              subtitle: Text(
                'Glicemia: ${daySummary["glucose"]} mg/dL\n'
                'Refeições: ${daySummary["meals"]}\n'
                'Atividades: ${daySummary["activities"]}',
              ),
            ),
          );
        },
      ),
    );
  }
}
