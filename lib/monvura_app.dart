import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/sleep_data_service.dart';
import 'theme/monvura_theme.dart';
import 'screens/chronotype_screen.dart';
import 'screens/dream_journal_screen.dart';
import 'screens/mood_correlation_screen.dart';
import 'screens/rest_sounds_screen.dart';

class MonvuraApp extends StatelessWidget {
  const MonvuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SleepDataService()..initialize(),
      child: MaterialApp(
        title: 'Monvura Rest & Dreamscapes',
        debugShowCheckedModeBanner: false,
        theme: MonvuraTheme.darkTheme,
        home: const _MonvuraShell(),
      ),
    );
  }
}

class _MonvuraShell extends StatefulWidget {
  const _MonvuraShell();

  @override
  State<_MonvuraShell> createState() => _MonvuraShellState();
}

class _MonvuraShellState extends State<_MonvuraShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ChronotypeScreen(),
    DreamJournalScreen(),
    MoodCorrelationScreen(),
    RestSoundsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.psychology_outlined),
            selectedIcon: Icon(Icons.psychology),
            label: 'Chronotype',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories),
            label: 'Dreams',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: 'Correlation',
          ),
          NavigationDestination(
            icon: Icon(Icons.graphic_eq_outlined),
            selectedIcon: Icon(Icons.graphic_eq),
            label: 'Mixer',
          ),
        ],
      ),
    );
  }
}
