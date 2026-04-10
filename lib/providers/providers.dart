import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/devotional.dart';
import '../services/devotional_engine.dart';
import '../services/journal_repository.dart';

// Repository instance
final journalRepoProvider = Provider<JournalRepository>((ref) {
  return JournalRepository();
});

// Signal for saved events
final lastSavedProvider = StateProvider<DateTime?>((ref) => null);

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
  return CurrentEntryNotifier(repo, ref, devotional);
});

class CurrentEntryNotifier extends StateNotifier<JournalEntry> {
  final JournalRepository _repo;
  final Ref _ref;

  CurrentEntryNotifier(this._repo, this._ref, DailyDevotional devotional)
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
    _ref.read(lastSavedProvider.notifier).state = DateTime.now();
  }
}

// All journal entries (sorted by date descending)
final journalEntriesProvider =
    StateNotifierProvider<JournalEntriesNotifier, List<JournalEntry>>((ref) {
  final repo = ref.read(journalRepoProvider);
  // Refresh when lastSaved changes
  ref.watch(lastSavedProvider);
  return JournalEntriesNotifier(repo);
});

class JournalEntriesNotifier extends StateNotifier<List<JournalEntry>> {
  final JournalRepository _repo;

  JournalEntriesNotifier(this._repo) : super([]) {
    refresh();
  }

  void refresh() {
    state = _repo.getAll();
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    refresh();
  }
}

// Streak count
final streakProvider = Provider<int>((ref) {
  ref.watch(currentEntryProvider);
  return ref.read(journalRepoProvider).getStreak();
});

// Available reading plans (with persistence)
final availablePlansProvider =
    StateNotifierProvider<PlansNotifier, List<ReadingPlan>>((ref) {
  final repo = ref.read(journalRepoProvider);
  return PlansNotifier(repo);
});

class PlansNotifier extends StateNotifier<List<ReadingPlan>> {
  final JournalRepository _repo;

  PlansNotifier(this._repo) : super([]) {
    _init();
  }

  void _init() {
    final savedPlans = _repo.getAllPlans();
    final enginePlans = DevotionalEngine.availablePlans;

    // Merge engine plans with saved progress
    final merged = enginePlans.map((ep) {
      final saved = savedPlans.where((sp) => sp.id == ep.id).firstOrNull;
      if (saved != null) {
        return ReadingPlan(
          id: ep.id,
          name: ep.name,
          description: ep.description,
          totalDays: ep.totalDays,
          readings: ep.readings,
          currentDay: saved.currentDay,
          startDate: saved.startDate,
        );
      }
      return ep;
    }).toList();

    state = merged;
  }

  Future<void> incrementDay(String planId) async {
    state = [
      for (final plan in state)
        if (plan.id == planId)
          ReadingPlan(
            id: plan.id,
            name: plan.name,
            description: plan.description,
            totalDays: plan.totalDays,
            readings: plan.readings,
            currentDay: (plan.currentDay + 1).clamp(0, plan.totalDays),
            startDate: plan.startDate,
          )
        else
          plan
    ];

    final updated = state.firstWhere((p) => p.id == planId);
    await _repo.savePlan(updated);
  }
}
