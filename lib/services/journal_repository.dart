import 'package:hive_flutter/hive_flutter.dart';
import '../models/devotional.dart';

class JournalRepository {
  static const _boxName = 'journal_entries';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  Box get _box => Hive.box(_boxName);

  Future<void> save(JournalEntry entry) async {
    await _box.put(entry.id, entry.toMap());
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  JournalEntry? get(String id) {
    final data = _box.get(id);
    if (data == null) return null;
    return JournalEntry.fromMap(Map<dynamic, dynamic>.from(data));
  }

  /// Get entry for a specific date (by date only, ignoring time).
  JournalEntry? getByDate(DateTime date) {
    final key = _dateKey(date);
    for (final entry in getAll()) {
      if (_dateKey(entry.date) == key) return entry;
    }
    return null;
  }

  List<JournalEntry> getAll() {
    return _box.values
        .map((data) => JournalEntry.fromMap(Map<dynamic, dynamic>.from(data)))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  int get count => _box.length;

  /// Get entries for a date range.
  List<JournalEntry> getRange(DateTime start, DateTime end) {
    return getAll().where((e) {
      return !e.date.isBefore(start) && !e.date.isAfter(end);
    }).toList();
  }

  /// Get all unique tags across all entries.
  Set<String> getAllTags() {
    final tags = <String>{};
    for (final entry in getAll()) {
      tags.addAll(entry.tags);
    }
    return tags;
  }

  /// Get streak count (consecutive days with entries ending today).
  int getStreak() {
    final entries = getAll();
    if (entries.isEmpty) return 0;

    final entryDates = entries.map((e) => _dateKey(e.date)).toSet();
    int streak = 0;
    var date = DateTime.now();

    while (entryDates.contains(_dateKey(date))) {
      streak++;
      date = date.subtract(const Duration(days: 1));
    }

    return streak;
  }

  String _dateKey(DateTime dt) => '${dt.year}-${dt.month}-${dt.day}';
}
