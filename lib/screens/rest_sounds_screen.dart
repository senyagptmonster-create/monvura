import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/sleep_data_service.dart';
import '../theme/monvura_theme.dart';

class RestSoundsScreen extends StatefulWidget {
  const RestSoundsScreen({super.key});

  @override
  State<RestSoundsScreen> createState() => _RestSoundsScreenState();
}

class _RestSoundsScreenState extends State<RestSoundsScreen> {
  int _sleepTimerMinutes = 30;

  final Map<String, IconData> _channelIcons = {
    'Nocturnal Rain': Icons.grain_rounded,
    'Delta Sleep Waves (2Hz)': Icons.waves_rounded,
    'Night Wind in Pines': Icons.air_rounded,
    'Distant Lunar Tide': Icons.water_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<SleepDataService>(context);
    final volumes = service.channelVolumes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Soundscape Mixer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Master Streaming Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    MonvuraTheme.violetPrimary.withAlpha(50),
                    MonvuraTheme.surfaceElevated,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: service.isMixerPlaying
                      ? MonvuraTheme.lavenderAccent
                      : MonvuraTheme.borderSubtle,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: service.isMixerPlaying
                          ? MonvuraTheme.violetPrimary
                          : MonvuraTheme.surfaceViolet,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      service.isMixerPlaying
                          ? Icons.music_note_rounded
                          : Icons.music_off_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.isMixerPlaying
                              ? 'Acoustic Sleep Field Active'
                              : 'Mixer Standby',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: MonvuraTheme.textHigh,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          service.isMixerPlaying
                              ? 'Timer: auto-off in $_sleepTimerMinutes mins'
                              : 'Tap play to blend sound layers',
                          style: const TextStyle(
                            fontSize: 12,
                            color: MonvuraTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      service.isMixerPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_fill_rounded,
                      size: 40,
                      color: MonvuraTheme.lavenderAccent,
                    ),
                    onPressed: service.toggleMixerPlayback,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Sleep Timer Presets
            const Text(
              'Fadeout Sleep Timer',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: MonvuraTheme.textHigh,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [15, 30, 45, 60, 90].map((mins) {
                final isSelected = _sleepTimerMinutes == mins;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text('$mins m'),
                      selected: isSelected,
                      selectedColor: MonvuraTheme.violetPrimary,
                      backgroundColor: MonvuraTheme.surfaceElevated,
                      labelStyle: TextStyle(
                        fontSize: 11,
                        color: isSelected ? Colors.white : MonvuraTheme.textHigh,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _sleepTimerMinutes = mins);
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Multi-channel Faders
            const Text(
              'Atmospheric Sound Layers',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: MonvuraTheme.textHigh,
              ),
            ),
            const SizedBox(height: 12),

            ...volumes.entries.map((entry) {
              final name = entry.key;
              final vol = entry.value;
              final icon = _channelIcons[name] ?? Icons.volume_up;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(icon, size: 20, color: MonvuraTheme.lavenderAccent),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: MonvuraTheme.textHigh,
                              ),
                            ),
                          ),
                          Text(
                            '${(vol * 100).toInt()}%',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: MonvuraTheme.lavenderAccent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Slider(
                        value: vol,
                        min: 0.0,
                        max: 1.0,
                        divisions: 20,
                        activeColor: MonvuraTheme.violetPrimary,
                        inactiveColor: MonvuraTheme.surfaceElevated,
                        onChanged: (v) => service.setChannelVolume(name, v),
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
