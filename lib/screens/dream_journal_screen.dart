import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/sleep_data_service.dart';
import '../theme/monvura_theme.dart';

class DreamJournalScreen extends StatefulWidget {
  const DreamJournalScreen({super.key});

  @override
  State<DreamJournalScreen> createState() => _DreamJournalScreenState();
}

class _DreamJournalScreenState extends State<DreamJournalScreen> {
  String _selectedMoodFilter = 'All';

  final List<String> _moodTags = [
    'All',
    'Lucid',
    'Serene',
    'Mystical',
    'Nightmarish',
    'Bizarre',
  ];

  Color _moodColor(String tag) {
    switch (tag.toLowerCase()) {
      case 'lucid':
        return MonvuraTheme.starGold;
      case 'serene':
        return const Color(0xFF34D399);
      case 'mystical':
        return MonvuraTheme.lavenderAccent;
      case 'nightmarish':
        return MonvuraTheme.roseMoon;
      case 'bizarre':
        return Colors.orangeAccent;
      default:
        return MonvuraTheme.lavenderAccent;
    }
  }

  void _showAddDreamDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String selectedTag = 'Lucid';
    int clarity = 4;
    bool isLucid = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: MonvuraTheme.surfaceViolet,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Record Hypnagogic Dream',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: MonvuraTheme.textHigh,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: MonvuraTheme.textMuted),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Dream Title (e.g. Flight over Crystal Canyon)',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Narrative & Dreamscape Details...',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Atmospheric Mood Tone',
                      style: TextStyle(fontSize: 12, color: MonvuraTheme.textMuted),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: ['Lucid', 'Serene', 'Mystical', 'Nightmarish', 'Bizarre'].map((tag) {
                        final isSel = selectedTag == tag;
                        return ChoiceChip(
                          label: Text(tag),
                          selected: isSel,
                          selectedColor: MonvuraTheme.violetPrimary,
                          backgroundColor: MonvuraTheme.surfaceElevated,
                          labelStyle: TextStyle(
                            color: isSel ? Colors.white : MonvuraTheme.textHigh,
                            fontSize: 12,
                          ),
                          onSelected: (val) {
                            if (val) {
                              setModalState(() {
                                selectedTag = tag;
                                if (tag == 'Lucid') isLucid = true;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Text(
                          'Dream Clarity: ',
                          style: TextStyle(fontSize: 13, color: MonvuraTheme.textHigh),
                        ),
                        Row(
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: Icon(
                                index < clarity ? Icons.star_rounded : Icons.star_border_rounded,
                                color: MonvuraTheme.starGold,
                                size: 22,
                              ),
                              onPressed: () => setModalState(() => clarity = index + 1),
                            );
                          }),
                        ),
                      ],
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Conscious Lucid Dream State'),
                      subtitle: const Text(
                        'Were you aware you were dreaming inside the REM cycle?',
                        style: TextStyle(fontSize: 11, color: MonvuraTheme.textMuted),
                      ),
                      value: isLucid,
                      activeThumbColor: MonvuraTheme.lavenderAccent,
                      onChanged: (val) => setModalState(() => isLucid = val),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final title = titleCtrl.text.trim();
                          if (title.isEmpty) return;
                          Provider.of<SleepDataService>(context, listen: false).addDream(
                            title: title,
                            description: descCtrl.text.trim().isEmpty
                                ? 'Unspecified recollection'
                                : descCtrl.text.trim(),
                            moodTag: selectedTag,
                            clarityRating: clarity,
                            isLucid: isLucid,
                          );
                          Navigator.pop(ctx);
                        },
                        child: const Text('Save Dream Entry'),
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
    final dreams = service.dreams;

    final filtered = dreams.where((d) {
      if (_selectedMoodFilter == 'All') return true;
      return d.moodTag.toLowerCase() == _selectedMoodFilter.toLowerCase();
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hypnagogic Dream Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Log Dream',
            onPressed: () => _showAddDreamDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: _moodTags.map((tag) {
                final isSel = _selectedMoodFilter == tag;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(tag),
                    selected: isSel,
                    selectedColor: MonvuraTheme.violetPrimary,
                    backgroundColor: MonvuraTheme.surfaceElevated,
                    labelStyle: TextStyle(
                      color: isSel ? Colors.white : MonvuraTheme.textHigh,
                      fontSize: 12,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                    ),
                    checkmarkColor: Colors.white,
                    onSelected: (val) {
                      if (val) setState(() => _selectedMoodFilter = tag);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.bedtime_outlined, size: 48, color: MonvuraTheme.textMuted),
                        SizedBox(height: 12),
                        Text(
                          'No dream logs recorded in this mood state.',
                          style: TextStyle(color: MonvuraTheme.textMuted),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) {
                      final dream = filtered[i];
                      final dateStr =
                          '${dream.date.year}-${dream.date.month.toString().padLeft(2, '0')}-${dream.date.day.toString().padLeft(2, '0')}';
                      final color = _moodColor(dream.moodTag);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dream.title,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: MonvuraTheme.textHigh,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          dateStr,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: MonvuraTheme.textDim,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: color.withAlpha(30),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: color.withAlpha(80)),
                                    ),
                                    child: Text(
                                      dream.moodTag,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: color,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                dream.description,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: MonvuraTheme.textHigh,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Row(
                                    children: List.generate(5, (starIdx) {
                                      return Icon(
                                        starIdx < dream.clarityRating
                                            ? Icons.star_rounded
                                            : Icons.star_border_rounded,
                                        size: 14,
                                        color: MonvuraTheme.starGold,
                                      );
                                    }),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Clarity ${dream.clarityRating}/5',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: MonvuraTheme.textMuted,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (dream.isLucid)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: MonvuraTheme.violetPrimary.withAlpha(40),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'LUCID',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: MonvuraTheme.lavenderAccent,
                                        ),
                                      ),
                                    ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      size: 18,
                                      color: MonvuraTheme.textDim,
                                    ),
                                    onPressed: () => service.removeDream(dream.id),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
