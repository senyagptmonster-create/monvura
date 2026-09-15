import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/sleep_data_service.dart';
import '../components/sleep_stat_card.dart';
import '../theme/monvura_theme.dart';

class MoodCorrelationScreen extends StatelessWidget {
  const MoodCorrelationScreen({super.key});

  String _moodName(int score) {
    switch (score) {
      case 1:
        return 'Drained';
      case 2:
        return 'Sluggish';
      case 3:
        return 'Neutral';
      case 4:
        return 'Energized';
      case 5:
        return 'Peak Flow';
      default:
        return 'Moderate';
    }
  }

  Color _moodColor(int score) {
    switch (score) {
      case 1:
        return MonvuraTheme.roseMoon;
      case 2:
        return Colors.orangeAccent;
      case 3:
        return MonvuraTheme.textMuted;
      case 4:
        return MonvuraTheme.lavenderAccent;
      case 5:
        return MonvuraTheme.starGold;
      default:
        return MonvuraTheme.lavenderAccent;
    }
  }

  void _showLogSleepDialog(BuildContext context, SleepDataService service) {
    double hours = 7.5;
    int quality = 85;
    int mood = 4;
    int deepSleep = 90;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: MonvuraTheme.surfaceViolet,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Log Rest & Next-Day Mood',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MonvuraTheme.textHigh,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Sleep Duration:',
                          style: TextStyle(color: MonvuraTheme.textHigh),
                        ),
                        Text(
                          '${hours.toStringAsFixed(1)} hours',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MonvuraTheme.lavenderAccent,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: hours,
                      min: 4.0,
                      max: 12.0,
                      divisions: 16,
                      activeColor: MonvuraTheme.violetPrimary,
                      onChanged: (v) => setDialogState(() => hours = v),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sleep Quality Score:',
                          style: TextStyle(color: MonvuraTheme.textHigh),
                        ),
                        Text(
                          '$quality%',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MonvuraTheme.starGold,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: quality.toDouble(),
                      min: 30,
                      max: 100,
                      divisions: 70,
                      activeColor: MonvuraTheme.starGold,
                      onChanged: (v) => setDialogState(() => quality = v.toInt()),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Deep Stage Rest (Minutes):',
                          style: TextStyle(color: MonvuraTheme.textHigh),
                        ),
                        Text(
                          '$deepSleep min',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MonvuraTheme.indigoGlow,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: deepSleep.toDouble(),
                      min: 20,
                      max: 180,
                      divisions: 32,
                      activeColor: MonvuraTheme.indigoGlow,
                      onChanged: (v) => setDialogState(() => deepSleep = v.toInt()),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Next-Day Cognitive & Emotional Tone',
                      style: TextStyle(color: MonvuraTheme.textHigh, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [1, 2, 3, 4, 5].map((val) {
                        final isSel = mood == val;
                        return InkWell(
                          onTap: () => setDialogState(() => mood = val),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSel ? MonvuraTheme.violetPrimary : MonvuraTheme.surfaceElevated,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$val★',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSel ? Colors.white : MonvuraTheme.textMuted,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          service.recordSleepNight(
                            hours: hours,
                            quality: quality,
                            mood: mood,
                            deepSleepMin: deepSleep,
                          );
                          Navigator.pop(ctx);
                        },
                        child: const Text('Save Correlation Data'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<SleepDataService>(context);
    final history = service.sleepHistory;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep & Mood Correlation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Log Rest Period',
            onPressed: () => _showLogSleepDialog(context, service),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Stat Cards
            Row(
              children: [
                Expanded(
                  child: SleepStatCard(
                    title: 'AVG DURATION',
                    value: '${service.averageSleepHours.toStringAsFixed(1)}h',
                    subtitle: 'Recommended: 7.5h - 8.5h',
                    icon: Icons.access_time_rounded,
                    accentColor: MonvuraTheme.lavenderAccent,
                    progress: (service.averageSleepHours / 10.0),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SleepStatCard(
                    title: 'AVG MOOD',
                    value: '${service.averageMoodScore.toStringAsFixed(1)} / 5',
                    subtitle: 'Post-rest subjective flow',
                    icon: Icons.sentiment_satisfied_alt_rounded,
                    accentColor: MonvuraTheme.starGold,
                    progress: (service.averageMoodScore / 5.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Correlation Chart Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MonvuraTheme.surfaceViolet,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: MonvuraTheme.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rest Hours vs Next-Day Mood Index',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: MonvuraTheme.textHigh,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Bar height = Sleep hours | Dot = Next day mood',
                    style: TextStyle(fontSize: 11, color: MonvuraTheme.textMuted),
                  ),
                  const SizedBox(height: 20),

                  // Correlation bars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: history.take(7).toList().reversed.map((record) {
                      final barHeight = (record.sleepHours * 14).clamp(30.0, 140.0);
                      final moodCol = _moodColor(record.nextDayMood);
                      final dayStr = '${record.date.month}/${record.date.day}';

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: moodCol.withAlpha(40),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.bolt,
                              size: 14,
                              color: moodCol,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 24,
                            height: barHeight,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  MonvuraTheme.violetPrimary,
                                  MonvuraTheme.indigoGlow,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${record.sleepHours.toStringAsFixed(1)}h',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: MonvuraTheme.textHigh,
                            ),
                          ),
                          Text(
                            dayStr,
                            style: const TextStyle(
                              fontSize: 9,
                              color: MonvuraTheme.textDim,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Detailed night log entries
            const Text(
              'Logged Rest Records',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: MonvuraTheme.textHigh,
              ),
            ),
            const SizedBox(height: 12),

            ...history.map((record) {
              final dateStr =
                  '${record.date.year}-${record.date.month.toString().padLeft(2, '0')}-${record.date.day.toString().padLeft(2, '0')}';
              final moodName = _moodName(record.nextDayMood);
              final moodColor = _moodColor(record.nextDayMood);

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: MonvuraTheme.surfaceElevated,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.nights_stay_rounded,
                          color: MonvuraTheme.lavenderAccent,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${record.sleepHours.toStringAsFixed(1)} hrs Sleep • ${record.qualityScore}% Quality',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: MonvuraTheme.textHigh,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Deep Stage: ${record.deepMinutes} min • $dateStr',
                              style: const TextStyle(
                                fontSize: 11,
                                color: MonvuraTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: moodColor.withAlpha(30),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: moodColor.withAlpha(80)),
                        ),
                        child: Text(
                          moodName,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: moodColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
