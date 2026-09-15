import 'package:flutter/material.dart';
import '../theme/monvura_theme.dart';

class MoodCorrelationView extends StatelessWidget {
  const MoodCorrelationView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'SLEEP DURATION TO COGNITIVE MOOD',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: MonvuraTheme.textSecondary),
          ),
          const SizedBox(height: 16),

          _buildBar('8.2 Hours Sleep -> Peak Calm & Alert', 0.92, const Color(0xFF10B981)),
          const SizedBox(height: 12),
          _buildBar('7.5 Hours Sleep -> High Baseline Focus', 0.80, MonvuraTheme.lavender),
          const SizedBox(height: 12),
          _buildBar('6.2 Hours Sleep -> Mild Afternoon Deficit', 0.58, const Color(0xFFF59E0B)),
          const SizedBox(height: 12),
          _buildBar('< 5.5 Hours Sleep -> Elevated Cortisol Stress', 0.32, Colors.redAccent),

          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: MonvuraTheme.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              'Neuroscience Insight: Slow-wave deep sleep consolidates declarative memory, while REM stage sleep processes emotional experiences from the waking day.',
              style: TextStyle(fontSize: 13, color: MonvuraTheme.textSecondary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double value, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MonvuraTheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: MonvuraTheme.textPrimary)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
