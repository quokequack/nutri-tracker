import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<Map<String, String>> activities = [];

  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  void _addActivity() {
    final activity = _activityController.text.trim();
    final duration = _durationController.text.trim();
    if (activity.isNotEmpty && duration.isNotEmpty) {
      setState(() {
        activities.add({'activity': activity, 'duration': duration});
      });
      _activityController.clear();
      _durationController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atividades Físicas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _activityController,
              decoration: const InputDecoration(
                labelText: 'Atividade (ex: Corrida)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _durationController,
              decoration: const InputDecoration(
                labelText: 'Duração (minutos)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addActivity,
              child: const Text('Adicionar Atividade'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: activities.isEmpty
                  ? const Center(child: Text('Nenhuma atividade registrada'))
                  : ListView.builder(
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        final activity = activities[index];
                        return ListTile(
                          leading: const Icon(Icons.fitness_center),
                          title: Text(activity['activity'] ?? ''),
                          subtitle: Text('${activity['duration']} minutos'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
