import 'package:flutter_test/flutter_test.dart';
import 'package:vespers/models/devotional.dart';

void main() {
  group('ScriptureReading', () {
    test('defaults to CSB translation', () {
      const reading =
          ScriptureReading(reference: 'John 3:16', text: 'For God so loved...');
      expect(reading.translation, 'CSB');
    });

    test('round-trips through Map', () {
      const reading = ScriptureReading(
        reference: 'Psalm 23:1',
        text: 'The LORD is my shepherd',
        translation: 'ESV',
      );
      final restored = ScriptureReading.fromMap(reading.toMap());
      expect(restored.reference, reading.reference);
      expect(restored.text, reading.text);
      expect(restored.translation, reading.translation);
    });
  });

  group('ReflectionPrompt', () {
    test('creates with question only', () {
      const prompt = ReflectionPrompt(question: 'What do you think?');
      expect(prompt.question, 'What do you think?');
      expect(prompt.hint, isNull);
    });

    test('round-trips through Map', () {
      const prompt = ReflectionPrompt(question: 'Why?', hint: 'Think deeply');
      final restored = ReflectionPrompt.fromMap(prompt.toMap());
      expect(restored.question, prompt.question);
      expect(restored.hint, prompt.hint);
    });
  });

  group('JournalEntry', () {
    test('creates with defaults', () {
      final entry = JournalEntry(id: '1', date: DateTime(2026, 4, 8));
      expect(entry.reflectionText, '');
      expect(entry.prayerText, '');
      expect(entry.tags, isEmpty);
      expect(entry.createdAt, isNotNull);
    });

    test('round-trips through Map', () {
      final entry = JournalEntry(
        id: 'test-entry',
        date: DateTime(2026, 4, 8),
        scriptureReference: 'Psalm 23:1',
        reflectionText: 'God is my shepherd',
        prayerText: 'Thank you Lord',
        tags: ['gratitude', 'trust'],
      );
      final restored = JournalEntry.fromMap(entry.toMap());
      expect(restored.id, entry.id);
      expect(restored.date.day, entry.date.day);
      expect(restored.scriptureReference, entry.scriptureReference);
      expect(restored.reflectionText, entry.reflectionText);
      expect(restored.prayerText, entry.prayerText);
      expect(restored.tags, entry.tags);
    });
  });

  group('ReadingPlan', () {
    test('calculates progress', () {
      final plan = ReadingPlan(
        id: 'test',
        name: 'Test Plan',
        totalDays: 10,
        readings: List.generate(
          10,
          (i) => ScriptureReading(reference: 'Gen ${i + 1}', text: ''),
        ),
        currentDay: 5,
      );
      expect(plan.progress, 0.5);
      expect(plan.isComplete, false);
    });

    test('isComplete when currentDay >= totalDays', () {
      final plan = ReadingPlan(
        id: 'done',
        name: 'Done Plan',
        totalDays: 3,
        readings: List.generate(
          3,
          (i) => ScriptureReading(reference: 'Gen ${i + 1}', text: ''),
        ),
        currentDay: 3,
      );
      expect(plan.isComplete, true);
      expect(plan.progress, 1.0);
    });

    test('todayReading returns current day reading', () {
      final plan = ReadingPlan(
        id: 'today',
        name: 'Today Plan',
        totalDays: 3,
        readings: [
          const ScriptureReading(reference: 'Gen 1', text: 'Day 1'),
          const ScriptureReading(reference: 'Gen 2', text: 'Day 2'),
          const ScriptureReading(reference: 'Gen 3', text: 'Day 3'),
        ],
        currentDay: 1,
      );
      expect(plan.todayReading?.reference, 'Gen 2');
    });

    test('round-trips through Map', () {
      final plan = ReadingPlan(
        id: 'roundtrip',
        name: 'Round Trip',
        description: 'Test plan',
        totalDays: 2,
        readings: [
          const ScriptureReading(reference: 'Gen 1', text: 'text1'),
          const ScriptureReading(reference: 'Gen 2', text: 'text2'),
        ],
        currentDay: 1,
      );
      final restored = ReadingPlan.fromMap(plan.toMap());
      expect(restored.id, plan.id);
      expect(restored.name, plan.name);
      expect(restored.description, plan.description);
      expect(restored.totalDays, plan.totalDays);
      expect(restored.readings.length, plan.readings.length);
      expect(restored.currentDay, plan.currentDay);
    });
  });

  group('DailyDevotional', () {
    test('creates with all fields', () {
      final devotional = DailyDevotional(
        date: DateTime(2026, 4, 8),
        title: 'Test Devotional',
        reading: const ScriptureReading(
          reference: 'John 1:1',
          text: 'In the beginning was the Word',
        ),
        prompts: const [
          ReflectionPrompt(question: 'What does this mean?'),
        ],
        prayerFocus: 'Understanding',
      );
      expect(devotional.title, 'Test Devotional');
      expect(devotional.reading.reference, 'John 1:1');
      expect(devotional.prompts.length, 1);
      expect(devotional.prayerFocus, 'Understanding');
    });
  });
}
