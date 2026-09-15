import 'package:flutter/material.dart';
import 'models/dream_entry.dart';
import 'theme/monvura_theme.dart';
import 'views/chronotype_audit_view.dart';
import 'views/dream_journal_view.dart';
import 'views/mood_correlation_view.dart';
import 'views/rest_waves_view.dart';

class MonvuraApp extends StatefulWidget {
  const MonvuraApp({super.key});

  @override
  State<MonvuraApp> createState() => _MonvuraAppState();
}

class _MonvuraAppState extends State<MonvuraApp> {
  final PageController _pageCtrl = PageController();
  int _currentPage = 0;

  final ValueNotifier<List<DreamEntry>> _dreamsNotifier = ValueNotifier<List<DreamEntry>>([
    DreamEntry(
      id: '1',
      title: 'Flying above geometric mountain peaks',
      description: 'Glided effortlessly over glowing neon cliffs with full conscious agency.',
      mood: 'Euphoric / Inspired',
      isLucid: true,
      recordedAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    DreamEntry(
      id: '2',
      title: 'Ancient labyrinth library archives',
      description: 'Endless spiral staircases of leatherbound manuscripts under starlight.',
      mood: 'Mysterious / Calm',
      isLucid: false,
      recordedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ]);

  @override
  void dispose() {
    _pageCtrl.dispose();
    _dreamsNotifier.dispose();
    super.dispose();
  }

  void _addDreamDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: MonvuraTheme.surface,
        title: const Text('Record Morning Dream'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Dream Title', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: descCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Details & Themes', border: OutlineInputBorder())),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: MonvuraTheme.indigo),
            onPressed: () {
              if (titleCtrl.text.trim().isNotEmpty) {
                final newEntry = DreamEntry(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  mood: 'Calm Reflection',
                  isLucid: false,
                  recordedAt: DateTime.now(),
                );
                _dreamsNotifier.value = [newEntry, ..._dreamsNotifier.value];
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save to Journal', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  final List<String> _pageTitles = const [
    'Chronotype Profile',
    'Dream Journal',
    'Sleep & Energy Sync',
    'Delta Rest Waves',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monvura Night Zen',
      debugShowCheckedModeBanner: false,
      theme: MonvuraTheme.themeData,
      home: Scaffold(
        appBar: AppBar(
          title: Text(_pageTitles[_currentPage]),
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                children: [
                  const ChronotypeAuditView(chronotype: 'The Bear'),
                  DreamJournalView(dreamsNotifier: _dreamsNotifier, onAddDream: _addDreamDialog),
                  const MoodCorrelationView(),
                  const RestWavesView(),
                ],
              ),
            ),

            // Dot Carousel Indicators
            Padding(
              padding: const EdgeInsets.only(bottom: 16, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final isSelected = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isSelected ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isSelected ? MonvuraTheme.indigo : Colors.white24,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
