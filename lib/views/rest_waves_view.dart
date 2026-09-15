import 'package:flutter/material.dart';
import '../theme/monvura_theme.dart';

class RestWavesView extends StatelessWidget {
  const RestWavesView({super.key});

  @override
  Widget build(BuildContext context) {
    final sounds = [
      {'title': 'Delta Sleep Waves 2.5Hz', 'type': 'Deep restorative slow wave sleep', 'icon': Icons.graphic_eq_rounded},
      {'title': 'Theta Dream Waves 5.0Hz', 'type': 'Hypnagogic transition & REM flow', 'icon': Icons.waves_rounded},
      {'title': 'Nocturnal Wind & Distant Tide', 'type': 'Natural organic frequency masking', 'icon': Icons.nights_stay_rounded},
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(18),
      itemCount: sounds.length,
      separatorBuilder: (context, _) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) {
        final s = sounds[i];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: MonvuraTheme.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(s['icon'] as IconData, color: MonvuraTheme.lavender, size: 26),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, color: MonvuraTheme.textPrimary)),
                    const SizedBox(height: 3),
                    Text(s['type'] as String, style: const TextStyle(fontSize: 12, color: MonvuraTheme.textSecondary)),
                  ],
                ),
              ),
              const Icon(Icons.play_circle_fill_rounded, color: MonvuraTheme.indigo, size: 30),
            ],
          ),
        );
      },
    );
  }
}
