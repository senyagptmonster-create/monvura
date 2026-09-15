import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/sleep_data_service.dart';
import '../theme/monvura_theme.dart';

class ChronotypeScreen extends StatefulWidget {
  const ChronotypeScreen({super.key});

  @override
  State<ChronotypeScreen> createState() => _ChronotypeScreenState();
}

class _ChronotypeScreenState extends State<ChronotypeScreen> {
  int _wakeTimeAnswer = 1; // 0=Early(Lion), 1=Normal(Bear), 2=Late(Wolf), 3=Irregular(Dolphin)
  int _peakFocusAnswer = 1;
  int _bedtimeAnswer = 1;

  final Map<String, Map<String, dynamic>> _chronotypeInfo = {
    'Bear': {
      'icon': Icons.wb_sunny_rounded,
      'color': MonvuraTheme.starGold,
      'title': 'The Solar Bear (50% of population)',
      'rhythm': 'Syncs naturally with the solar cycle. Peak focus 10:00 AM - 2:00 PM.',
      'bedtime': '10:30 PM - 11:00 PM',
      'wakeup': '7:00 AM',
      'windDown': 'Dim screens by 9:30 PM. Warm herbal infusion.',
    },
    'Lion': {
      'icon': Icons.wb_twilight_rounded,
      'color': MonvuraTheme.roseMoon,
      'title': 'The Early Lion (15% of population)',
      'rhythm': 'Energized at sunrise. Explosive morning cognitive output 8:00 AM - 12:00 PM.',
      'bedtime': '9:30 PM - 10:00 PM',
      'wakeup': '5:30 AM',
      'windDown': 'Avoid heavy physical exertion past 6:00 PM.',
    },
    'Wolf': {
      'icon': Icons.nightlight_round,
      'color': MonvuraTheme.indigoGlow,
      'title': 'The Nocturnal Wolf (20% of population)',
      'rhythm': 'Slow morning awakenings. Peak creative surge 5:00 PM - 11:00 PM.',
      'bedtime': '12:30 AM - 1:00 AM',
      'wakeup': '8:30 AM',
      'windDown': 'Use amber lighting; avoid caffeine post 3:00 PM.',
    },
    'Dolphin': {
      'icon': Icons.waves_rounded,
      'color': MonvuraTheme.lavenderAccent,
      'title': 'The Sensitive Dolphin (15% of population)',
      'rhythm': 'Light, vigilant sleeper. Bursts of intense mental clarity 3:00 PM - 7:00 PM.',
      'bedtime': '11:30 PM - 12:00 AM',
      'wakeup': '6:30 AM',
      'windDown': 'Magnesium glycinate & white noise essential.',
    },
  };

  void _calculateAndApply(SleepDataService service) {
    // Score map
    final scores = {'Lion': 0, 'Bear': 0, 'Wolf': 0, 'Dolphin': 0};

    if (_wakeTimeAnswer == 0) scores['Lion'] = scores['Lion']! + 2;
    if (_wakeTimeAnswer == 1) scores['Bear'] = scores['Bear']! + 2;
    if (_wakeTimeAnswer == 2) scores['Wolf'] = scores['Wolf']! + 2;
    if (_wakeTimeAnswer == 3) scores['Dolphin'] = scores['Dolphin']! + 2;

    if (_peakFocusAnswer == 0) scores['Lion'] = scores['Lion']! + 2;
    if (_peakFocusAnswer == 1) scores['Bear'] = scores['Bear']! + 2;
    if (_peakFocusAnswer == 2) scores['Wolf'] = scores['Wolf']! + 2;
    if (_peakFocusAnswer == 3) scores['Dolphin'] = scores['Dolphin']! + 2;

    if (_bedtimeAnswer == 0) scores['Lion'] = scores['Lion']! + 2;
    if (_bedtimeAnswer == 1) scores['Bear'] = scores['Bear']! + 2;
    if (_bedtimeAnswer == 2) scores['Wolf'] = scores['Wolf']! + 2;
    if (_bedtimeAnswer == 3) scores['Dolphin'] = scores['Dolphin']! + 2;

    var bestType = 'Bear';
    var maxScore = -1;
    scores.forEach((key, val) {
      if (val > maxScore) {
        maxScore = val;
        bestType = key;
      }
    });

    final percentage = 70 + (maxScore * 5);
    service.updateChronotype(bestType, percentage);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Chronotype recalibrated: $bestType archetype ($percentage% match)'),
        backgroundColor: MonvuraTheme.surfaceElevated,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<SleepDataService>(context);
    final currentChrono = service.chronotype;
    final info = _chronotypeInfo[currentChrono] ?? _chronotypeInfo['Bear']!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Circadian Chronotype'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current profile card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    (info['color'] as Color).withAlpha(40),
                    MonvuraTheme.surfaceElevated,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: (info['color'] as Color).withAlpha(100),
                  width: 1.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (info['color'] as Color).withAlpha(60),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          info['icon'] as IconData,
                          color: info['color'] as Color,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              info['title'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MonvuraTheme.textHigh,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Circadian Match: ${service.chronotypeScore}% alignment',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: info['color'] as Color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    info['rhythm'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      color: MonvuraTheme.textHigh,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _chronotypeBadge('Wake', info['wakeup'] as String),
                      const SizedBox(width: 10),
                      _chronotypeBadge('Bedtime', info['bedtime'] as String),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recalibration Diagnostic Quiz
            const Text(
              'Chronotype Assessment Diagnostic',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: MonvuraTheme.textHigh,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Answer these questions to adjust your biological sleep window.',
              style: TextStyle(fontSize: 12, color: MonvuraTheme.textMuted),
            ),
            const SizedBox(height: 16),

            // Question 1
            _quizSection(
              question: '1. What time would you naturally wake up without an alarm?',
              options: const ['Before 6:30 AM', '7:00 AM - 8:00 AM', 'After 9:00 AM', 'Varies / Fragmented'],
              selectedIndex: _wakeTimeAnswer,
              onSelected: (i) => setState(() => _wakeTimeAnswer = i),
            ),
            const SizedBox(height: 14),

            // Question 2
            _quizSection(
              question: '2. When is your cognitive clarity and energy highest?',
              options: const ['First 4 hours awake', 'Late morning to mid-afternoon', 'Late evening / Night', 'Random energetic bursts'],
              selectedIndex: _peakFocusAnswer,
              onSelected: (i) => setState(() => _peakFocusAnswer = i),
            ),
            const SizedBox(height: 14),

            // Question 3
            _quizSection(
              question: '3. When do you feel naturally drowsy?',
              options: const ['9:00 PM - 10:00 PM', '10:30 PM - 11:30 PM', 'After Midnight', 'Late with difficulty settling'],
              selectedIndex: _bedtimeAnswer,
              onSelected: (i) => setState(() => _bedtimeAnswer = i),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _calculateAndApply(service),
                icon: const Icon(Icons.psychology_outlined, size: 20),
                label: const Text('Update Chronotype Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chronotypeBadge(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: MonvuraTheme.surfaceViolet,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: MonvuraTheme.borderSubtle),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 11, color: MonvuraTheme.textMuted),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: MonvuraTheme.textHigh,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quizSection({
    required String question,
    required List<String> options,
    required int selectedIndex,
    required ValueChanged<int> onSelected,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: MonvuraTheme.textHigh,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: List.generate(options.length, (idx) {
                final isSelected = selectedIndex == idx;
                return InkWell(
                  onTap: () => onSelected(idx),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? MonvuraTheme.violetPrimary.withAlpha(40)
                          : MonvuraTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? MonvuraTheme.lavenderAccent
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          size: 16,
                          color: isSelected
                              ? MonvuraTheme.lavenderAccent
                              : MonvuraTheme.textMuted,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            options[idx],
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? MonvuraTheme.textHigh
                                  : MonvuraTheme.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
