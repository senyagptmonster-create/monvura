import 'package:flutter/material.dart';
import '../painters/sleep_chronotype_painter.dart';
import '../theme/monvura_theme.dart';

class ChronotypeAuditView extends StatelessWidget {
  final String chronotype;

  const ChronotypeAuditView({super.key, required this.chronotype});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Circular Circadian Dial
          Center(
            child: SizedBox(
              width: 220,
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(220, 220),
                    painter: SleepChronotypePainter(chronotype: chronotype),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bedtime_rounded, color: MonvuraTheme.lavender, size: 32),
                      const SizedBox(height: 4),
                      Text(
                        chronotype,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: MonvuraTheme.textPrimary),
                      ),
                      const Text('55% of Humans', style: TextStyle(fontSize: 11, color: MonvuraTheme.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Schedule Spec Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: MonvuraTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: MonvuraTheme.indigo.withValues(alpha: 0.3)),
            ),
            child: const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Optimal Sleep Window', style: TextStyle(color: MonvuraTheme.textSecondary)),
                    Text('23:00 - 07:00', style: TextStyle(fontWeight: FontWeight.bold, color: MonvuraTheme.lavender)),
                  ],
                ),
                Divider(color: Colors.white10, height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Peak Cognitive Focus', style: TextStyle(color: MonvuraTheme.textSecondary)),
                    Text('10:00 - 14:00', style: TextStyle(fontWeight: FontWeight.bold, color: MonvuraTheme.cyan)),
                  ],
                ),
                Divider(color: Colors.white10, height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Physical Exercise Peak', style: TextStyle(color: MonvuraTheme.textSecondary)),
                    Text('16:30 - 18:30', style: TextStyle(fontWeight: FontWeight.bold, color: MonvuraTheme.textPrimary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: MonvuraTheme.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              'The Bear Chronotype is tuned directly to the solar cycle. Waking with morning sunlight optimizes cortisol and stabilizes evening melatonin release.',
              style: TextStyle(fontSize: 13, color: MonvuraTheme.textSecondary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
