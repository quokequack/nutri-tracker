import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GlucoseScreen extends StatefulWidget {
  const GlucoseScreen({super.key});

  @override
  State<GlucoseScreen> createState() => _GlucoseScreenState();
}

class _GlucoseScreenState extends State<GlucoseScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _addReading() async {
    await firestore.collection('glicemias').add({
      'valor': 130,
      'horario': '18:00',
      'createdAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Glicemia adicionada')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Glicemia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addReading,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('glicemias')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar dados.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('Nenhuma medição registrada.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final valor = doc['valor'];
              final horario = doc['horario'];

              return ListTile(
                leading: const Icon(Icons.monitor_heart),
                title: Text('$valor mg/dL'),
                subtitle: Text('Horário: $horario'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await firestore.collection('glicemias').doc(doc.id).delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Leitura excluída')),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
