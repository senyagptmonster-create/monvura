import 'package:flutter/material.dart';
import '../models/dream_entry.dart';
import '../theme/monvura_theme.dart';

class DreamJournalView extends StatelessWidget {
  final ValueNotifier<List<DreamEntry>> dreamsNotifier;
  final VoidCallback onAddDream;

  const DreamJournalView({
    super.key,
    required this.dreamsNotifier,
    required this.onAddDream,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<DreamEntry>>(
      valueListenable: dreamsNotifier,
      builder: (context, dreams, _) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            backgroundColor: MonvuraTheme.indigo,
            foregroundColor: Colors.white,
            onPressed: onAddDream,
            child: const Icon(Icons.add),
          ),
          body: dreams.isEmpty
              ? const Center(child: Text('No dream reflections logged yet', style: TextStyle(color: MonvuraTheme.textSecondary)))
              : ListView.separated(
                  padding: const EdgeInsets.all(18),
                  itemCount: dreams.length,
                  separatorBuilder: (context, _) => const SizedBox(height: 10),
                  itemBuilder: (ctx, i) {
                    final d = dreams[i];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: MonvuraTheme.surface,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(d.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: MonvuraTheme.textPrimary)),
                              if (d.isLucid)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: MonvuraTheme.indigo.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(6)),
                                  child: const Text('LUCID', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: MonvuraTheme.lavender)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(d.description, style: const TextStyle(fontSize: 13, color: MonvuraTheme.textSecondary, height: 1.3)),
                          const SizedBox(height: 10),
                          Text('Mood Tag: ${d.mood}', style: const TextStyle(fontSize: 11, color: MonvuraTheme.cyan, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
