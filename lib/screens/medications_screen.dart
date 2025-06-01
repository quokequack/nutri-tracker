import 'package:flutter/material.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  List<String> medications = [];

  final TextEditingController _controller = TextEditingController();

  void _addMedication() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        medications.add(text);
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicamentos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Adicionar medicamento',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _addMedication(),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addMedication,
              child: const Text('Adicionar'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: medications.isEmpty
                  ? const Center(child: Text('Nenhum medicamento adicionado'))
                  : ListView.builder(
                      itemCount: medications.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.medication),
                          title: Text(medications[index]),
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
