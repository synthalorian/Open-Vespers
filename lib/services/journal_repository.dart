import 'package:hive_flutter/hive_flutter.dart';
import '../models/devotional.dart';

class JournalRepository {
  static const _journalBox = 'journal_entries';
  static const _planBox = 'reading_plans';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_journalBox);
    await Hive.openBox(_planBox);
  }

  Box get _jBox => Hive.box(_journalBox);
  Box get _pBox => Hive.box(_planBox);

  // Journal Methods
  Future<void> save(JournalEntry entry) async {
    await _jBox.put(entry.id, entry.toMap());
  }

  Future<void> delete(String id) async {
    await _jBox.delete(id);
  }

  JournalEntry? get(String id) {
    final data = _jBox.get(id);
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
    return _jBox.values
        .map((data) => JournalEntry.fromMap(Map<dynamic, dynamic>.from(data)))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  int get count => _jBox.length;

  // Plan Methods
  Future<void> savePlan(ReadingPlan plan) async {
    await _pBox.put(plan.id, plan.toMap());
  }

  ReadingPlan? getPlan(String id) {
    final data = _pBox.get(id);
    if (data == null) return null;
    return ReadingPlan.fromMap(Map<dynamic, dynamic>.from(data));
  }

  List<ReadingPlan> getAllPlans() {
    return _pBox.values
        .map((data) => ReadingPlan.fromMap(Map<dynamic, dynamic>.from(data)))
        .toList();
  }

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
