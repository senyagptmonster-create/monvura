import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DreamEntry {
  final String id;
  final DateTime date;
  final String title;
  final String description;
  final String moodTag;
  final int clarityRating; // 1 to 5
  final bool isLucid;

  DreamEntry({
    required this.id,
    required this.date,
    required this.title,
    required this.description,
    required this.moodTag,
    required this.clarityRating,
    required this.isLucid,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'title': title,
        'description': description,
        'moodTag': moodTag,
        'clarityRating': clarityRating,
        'isLucid': isLucid,
      };

  factory DreamEntry.fromJson(Map<String, dynamic> json) => DreamEntry(
        id: json['id'] as String,
        date: DateTime.parse(json['date'] as String),
        title: json['title'] as String,
        description: json['description'] as String,
        moodTag: json['moodTag'] as String,
        clarityRating: json['clarityRating'] as int,
        isLucid: json['isLucid'] as bool? ?? false,
      );
}

class SleepRecord {
  final String id;
  final DateTime date;
  final double sleepHours;
  final int qualityScore; // 1 to 100
  final int nextDayMood; // 1 (Drained) to 5 (Peak Flow)
  final int deepMinutes;

  SleepRecord({
    required this.id,
    required this.date,
    required this.sleepHours,
    required this.qualityScore,
    required this.nextDayMood,
    required this.deepMinutes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'sleepHours': sleepHours,
        'qualityScore': qualityScore,
        'nextDayMood': nextDayMood,
        'deepMinutes': deepMinutes,
      };

  factory SleepRecord.fromJson(Map<String, dynamic> json) => SleepRecord(
        id: json['id'] as String,
        date: DateTime.parse(json['date'] as String),
        sleepHours: (json['sleepHours'] as num).toDouble(),
        qualityScore: json['qualityScore'] as int,
        nextDayMood: json['nextDayMood'] as int,
        deepMinutes: json['deepMinutes'] as int,
      );
}

class SleepDataService extends ChangeNotifier {
  static const String _dreamsKey = 'monvura_dreams_v1';
  static const String _sleepRecordsKey = 'monvura_records_v1';
  static const String _chronotypeKey = 'monvura_chronotype_v1';

  List<DreamEntry> _dreams = [];
  List<SleepRecord> _sleepHistory = [];
  String _chronotype = 'Bear';
  int _chronotypeScore = 78;
  bool _isInitialized = false;

  // Sound mixer state
  bool _isMixerPlaying = false;
  final Map<String, double> _channelVolumes = {
    'Nocturnal Rain': 0.7,
    'Delta Sleep Waves (2Hz)': 0.5,
    'Night Wind in Pines': 0.4,
    'Distant Lunar Tide': 0.3,
  };

  List<DreamEntry> get dreams => List.unmodifiable(_dreams);
  List<SleepRecord> get sleepHistory => List.unmodifiable(_sleepHistory);
  String get chronotype => _chronotype;
  int get chronotypeScore => _chronotypeScore;
  bool get isMixerPlaying => _isMixerPlaying;
  Map<String, double> get channelVolumes => Map.unmodifiable(_channelVolumes);
  bool get isInitialized => _isInitialized;

  double get averageSleepHours {
    if (_sleepHistory.isEmpty) return 7.5;
    return _sleepHistory.map((s) => s.sleepHours).reduce((a, b) => a + b) /
        _sleepHistory.length;
  }

  double get averageMoodScore {
    if (_sleepHistory.isEmpty) return 4.0;
    return _sleepHistory.map((s) => s.nextDayMood).reduce((a, b) => a + b) /
        _sleepHistory.length;
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final dreamsJson = prefs.getString(_dreamsKey);
      if (dreamsJson != null && dreamsJson.isNotEmpty) {
        final decoded = jsonDecode(dreamsJson) as List<dynamic>;
        _dreams = decoded
            .map((e) => DreamEntry.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        _dreams = _seedDreams();
        await _saveDreams();
      }

      final recordsJson = prefs.getString(_sleepRecordsKey);
      if (recordsJson != null && recordsJson.isNotEmpty) {
        final decoded = jsonDecode(recordsJson) as List<dynamic>;
        _sleepHistory = decoded
            .map((e) => SleepRecord.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        _sleepHistory = _seedSleepHistory();
        await _saveSleep();
      }

      final chrono = prefs.getString(_chronotypeKey);
      if (chrono != null && chrono.isNotEmpty) {
        _chronotype = chrono;
      }
    } catch (e) {
      debugPrint('Error loading Monvura data: $e');
      _dreams = _seedDreams();
      _sleepHistory = _seedSleepHistory();
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _saveDreams() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(_dreams.map((d) => d.toJson()).toList());
    await prefs.setString(_dreamsKey, data);
  }

  Future<void> _saveSleep() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(_sleepHistory.map((s) => s.toJson()).toList());
    await prefs.setString(_sleepRecordsKey, data);
  }

  Future<void> addDream({
    required String title,
    required String description,
    required String moodTag,
    required int clarityRating,
    required bool isLucid,
  }) async {
    final dream = DreamEntry(
      id: 'dream_${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      title: title,
      description: description,
      moodTag: moodTag,
      clarityRating: clarityRating,
      isLucid: isLucid,
    );
    _dreams.insert(0, dream);
    await _saveDreams();
    notifyListeners();
  }

  Future<void> removeDream(String id) async {
    _dreams.removeWhere((d) => d.id == id);
    await _saveDreams();
    notifyListeners();
  }

  Future<void> recordSleepNight({
    required double hours,
    required int quality,
    required int mood,
    required int deepSleepMin,
  }) async {
    final record = SleepRecord(
      id: 'rec_${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      sleepHours: hours,
      qualityScore: quality,
      nextDayMood: mood,
      deepMinutes: deepSleepMin,
    );
    _sleepHistory.insert(0, record);
    await _saveSleep();
    notifyListeners();
  }

  Future<void> updateChronotype(String type, int score) async {
    _chronotype = type;
    _chronotypeScore = score;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chronotypeKey, type);
    notifyListeners();
  }

  void toggleMixerPlayback() {
    _isMixerPlaying = !_isMixerPlaying;
    notifyListeners();
  }

  void setChannelVolume(String channel, double volume) {
    _channelVolumes[channel] = volume.clamp(0.0, 1.0);
    notifyListeners();
  }

  List<DreamEntry> _seedDreams() {
    return [
      DreamEntry(
        id: 'd_1',
        date: DateTime.now().subtract(const Duration(days: 1)),
        title: 'Bioluminescent Glade & Glass Bridge',
        description:
            'Walking across an arched glass viaduct surrounded by floating crystalline fireflies. Complete awareness of dreaming.',
        moodTag: 'Lucid',
        clarityRating: 5,
        isLucid: true,
      ),
      DreamEntry(
        id: 'd_2',
        date: DateTime.now().subtract(const Duration(days: 3)),
        title: 'Submerged Obsidian Library',
        description:
            'Water filled ancient halls with glowing floating parchment scrolls. Calm and solemn feeling.',
        moodTag: 'Mystical',
        clarityRating: 4,
        isLucid: false,
      ),
      DreamEntry(
        id: 'd_3',
        date: DateTime.now().subtract(const Duration(days: 5)),
        title: 'Endless Flight over Cobalt Peaks',
        description:
            'Gliding seamlessly with the evening wind currents above snow-capped obsidian mountain ranges.',
        moodTag: 'Serene',
        clarityRating: 4,
        isLucid: false,
      ),
    ];
  }

  List<SleepRecord> _seedSleepHistory() {
    return [
      SleepRecord(
        id: 'sr_1',
        date: DateTime.now().subtract(const Duration(days: 1)),
        sleepHours: 8.2,
        qualityScore: 92,
        nextDayMood: 5,
        deepMinutes: 115,
      ),
      SleepRecord(
        id: 'sr_2',
        date: DateTime.now().subtract(const Duration(days: 2)),
        sleepHours: 7.5,
        qualityScore: 84,
        nextDayMood: 4,
        deepMinutes: 98,
      ),
      SleepRecord(
        id: 'sr_3',
        date: DateTime.now().subtract(const Duration(days: 3)),
        sleepHours: 6.1,
        qualityScore: 65,
        nextDayMood: 2,
        deepMinutes: 52,
      ),
      SleepRecord(
        id: 'sr_4',
        date: DateTime.now().subtract(const Duration(days: 4)),
        sleepHours: 8.0,
        qualityScore: 88,
        nextDayMood: 4,
        deepMinutes: 104,
      ),
      SleepRecord(
        id: 'sr_5',
        date: DateTime.now().subtract(const Duration(days: 5)),
        sleepHours: 7.8,
        qualityScore: 86,
        nextDayMood: 5,
        deepMinutes: 110,
      ),
      SleepRecord(
        id: 'sr_6',
        date: DateTime.now().subtract(const Duration(days: 6)),
        sleepHours: 5.8,
        qualityScore: 58,
        nextDayMood: 1,
        deepMinutes: 44,
      ),
    ];
  }
}
