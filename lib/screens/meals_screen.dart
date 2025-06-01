import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _mealNameController = TextEditingController();
  final TextEditingController _mealTimeController = TextEditingController();
  bool _isLoading = false;

  Future<void> addMeal(String name, String time) async {
    setState(() => _isLoading = true);
    try {
      await firestore.collection('refeicoes').add({
        'nome': name, 
        'horario': time,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _mealNameController.clear();
      _mealTimeController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showAddMealDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Refeição'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _mealNameController,
                decoration: const InputDecoration(labelText: 'Nome da Refeição'),
              ),
              TextField(
                controller: _mealTimeController,
                decoration: const InputDecoration(labelText: 'Horário (ex: 15:00)'),
                keyboardType: TextInputType.datetime,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_mealNameController.text.isNotEmpty &&
                    _mealTimeController.text.isNotEmpty) {
                  await addMeal(
                    _mealNameController.text,
                    _mealTimeController.text,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _shareMeals(List<QueryDocumentSnapshot> mealsDocs) {
    if (mealsDocs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhuma refeição para compartilhar')),
      );
      return;
    }

    String text = "Minhas refeições:\n";
    for (var doc in mealsDocs) {
      text += "${doc['nome']} às ${doc['horario']}\n";
    }
    Share.share(text);
  }

  @override
  void dispose() {
    _mealNameController.dispose();
    _mealTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Refeições')),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMealDialog,
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('refeicoes') 
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final mealsDocs = snapshot.data!.docs;

          return Column(
            children: [
              if (mealsDocs.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () => _shareMeals(mealsDocs),
                      icon: const Icon(Icons.share),
                      label: const Text('Compartilhar'),
                    ),
                  ),
                ),
              if (mealsDocs.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text('Nenhuma refeição registrada ainda'),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: mealsDocs.length,
                    itemBuilder: (context, index) {
                      final meal = mealsDocs[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.restaurant, size: 30),
                          title: Text(
                            meal['nome'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Horário: ${meal['horario']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await firestore 
                                  .collection('refeicoes')
                                  .doc(meal.id)
                                  .delete();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
