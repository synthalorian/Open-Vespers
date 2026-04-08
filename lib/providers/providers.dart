import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/devotional.dart';
import '../services/devotional_engine.dart';
import '../services/journal_repository.dart';

// Repository instance
final journalRepoProvider = Provider<JournalRepository>((ref) {
  return JournalRepository();
});

// Today's devotional
final todayDevotionalProvider = Provider<DailyDevotional>((ref) {
  return DevotionalEngine.getToday();
});

// Devotional for a specific date
final devotionalForDateProvider =
    Provider.family<DailyDevotional, DateTime>((ref, date) {
  return DevotionalEngine.getForDate(date);
});

// Current journal entry (for today or selected date)
final currentEntryProvider =
    StateNotifierProvider<CurrentEntryNotifier, JournalEntry>((ref) {
  final repo = ref.read(journalRepoProvider);
  final devotional = ref.read(todayDevotionalProvider);
  return CurrentEntryNotifier(repo, devotional);
});

class CurrentEntryNotifier extends StateNotifier<JournalEntry> {
  final JournalRepository _repo;

  CurrentEntryNotifier(this._repo, DailyDevotional devotional)
      : super(_loadOrCreate(_repo, devotional));

  static JournalEntry _loadOrCreate(
      JournalRepository repo, DailyDevotional devotional) {
    final existing = repo.getByDate(DateTime.now());
    if (existing != null) return existing;
    return JournalEntry(
      id: DateTime.now().toIso8601String(),
      date: DateTime.now(),
      scriptureReference: devotional.reading.reference,
    );
  }

  void updateReflection(String text) {
    state = JournalEntry(
      id: state.id,
      date: state.date,
      scriptureReference: state.scriptureReference,
      reflectionText: text,
      prayerText: state.prayerText,
      tags: state.tags,
      createdAt: state.createdAt,
    );
  }

  void updatePrayer(String text) {
    state = JournalEntry(
      id: state.id,
      date: state.date,
      scriptureReference: state.scriptureReference,
      reflectionText: state.reflectionText,
      prayerText: text,
      tags: state.tags,
      createdAt: state.createdAt,
    );
  }

  Future<void> save() async {
    await _repo.save(state);
  }
}

// All journal entries (sorted by date descending)
final journalEntriesProvider = Provider<List<JournalEntry>>((ref) {
  // Watch the current entry so list refreshes after save
  ref.watch(currentEntryProvider);
  return ref.read(journalRepoProvider).getAll();
});

// Streak count
final streakProvider = Provider<int>((ref) {
  ref.watch(currentEntryProvider);
  return ref.read(journalRepoProvider).getStreak();
});

// Available reading plans
final availablePlansProvider = Provider<List<ReadingPlan>>((ref) {
  return DevotionalEngine.availablePlans;
});
