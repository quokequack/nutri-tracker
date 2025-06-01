import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/meals_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/glucose_screen.dart';
import 'screens/medications_screen.dart';
import 'screens/activity_screen.dart';
import 'screens/summary_screen.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
    future: Firebase.initializeApp(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return MaterialApp(
          title: 'NutriTrack',
          theme: ThemeData(primarySwatch: Colors.green),
          home: const MainScreen(),
        );
      }

      if (snapshot.hasError) {
        return const MaterialApp(
          home: Scaffold(
            body: Center(child: Text('Erro ao inicializar o Firebase')),
          ),
        );
      }

      // Enquanto carrega
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    },
  );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    MealsScreen(),
    ReportsScreen(),
    GlucoseScreen(),
    MedicationsScreen(),
    ActivityScreen(),
    SummaryScreen(),
  ];

  final List<String> _screenTitles = [
    'Início', 
    'Refeições',
    'Relatórios',
    'Glucose',
    'Medicação',
    'Atividade',
    'Sumário',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screenTitles[_currentIndex]),
      ),
      body: _screens[_currentIndex],
      drawer: Drawer( 
        child: ListView( 
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text('NutriTracker', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            for (int i = 0; i < _screens.length; i++)
              ListTile(
                leading: _getIconForIndex(i),
                title: Text(_screenTitles[i]),
                selected: i == _currentIndex,
                onTap: () {
                  setState(() {
                    _currentIndex = i;
                  });
                  Navigator.pop(context); 
                },
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex > 4 ? 0 : _currentIndex, 
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Refeições'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Relatórios'),
          BottomNavigationBarItem(icon: Icon(Icons.medication_outlined), label: 'Glucose'),
          BottomNavigationBarItem(icon: Icon(Icons.local_pharmacy), label: 'Medicação'),
        ],
      ),
    );
  }

  Icon _getIconForIndex(int i) {
    switch (i) {
      case 0:
        return const Icon(Icons.home);
      case 1:
        return const Icon(Icons.restaurant);
      case 2:
        return const Icon(Icons.bar_chart);
      case 3:
        return const Icon(Icons.medication_outlined);
      case 4:
        return const Icon(Icons.local_pharmacy);
      case 5:
        return const Icon(Icons.fitness_center);
      case 6:
        return const Icon(Icons.insert_chart);
      default:
        return const Icon(Icons.help);
    }
  }
}
