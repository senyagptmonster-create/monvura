import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/brand.dart';
import 'screens.dart';
import 'monvura_store.dart';

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MonvuraStore(),
      child: MaterialApp(
        title: 'Monvura',
        theme: ThemeData(
          scaffoldBackgroundColor: cBg,
          colorScheme: ColorScheme.light(primary: cInk, secondary: cAccent),
        ),
        home: MonvuraHome(),
      ),
    );
  }
}

class MonvuraHome extends StatefulWidget {
  const MonvuraHome({super.key});

  @override
  _MonvuraHomeState createState() => _MonvuraHomeState();
}

class _MonvuraHomeState extends State<MonvuraHome> {
  int _idx = 0;
  final _screens = [
    ChronotypeAssessmentScreen(),
    DreamJournalLogScreen(),
    CorrelationChartsScreen(),
    WhiteNoiseScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        onTap: (i) {
          setState(() {
            _idx = i;
          });
        },
        selectedItemColor: cAccent,
        unselectedItemColor: cInk.withValues(alpha: 0.5),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.assessment), label: 'Chronotype'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Mood'),
          BottomNavigationBarItem(icon: Icon(Icons.waves), label: 'Sounds'),
        ],
      ),
    );
  }
}
