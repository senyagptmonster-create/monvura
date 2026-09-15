class DreamEntry {
  final String id;
  final String title;
  final String description;
  final String mood;
  final bool isLucid;
  final DateTime recordedAt;

  const DreamEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.mood,
    required this.isLucid,
    required this.recordedAt,
  });
}
