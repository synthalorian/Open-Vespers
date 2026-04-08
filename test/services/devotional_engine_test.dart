import 'package:flutter_test/flutter_test.dart';
import 'package:vespers/services/devotional_engine.dart';

void main() {
  group('DevotionalEngine', () {
    test('getToday returns a devotional', () {
      final devotional = DevotionalEngine.getToday();
      expect(devotional.reading.reference, isNotEmpty);
      expect(devotional.reading.text, isNotEmpty);
      expect(devotional.date.day, DateTime.now().day);
    });

    test('getForDate returns consistent result for same date', () {
      final date = DateTime(2026, 4, 8);
      final a = DevotionalEngine.getForDate(date);
      final b = DevotionalEngine.getForDate(date);
      expect(a.reading.reference, b.reading.reference);
      expect(a.title, b.title);
    });

    test('different dates get different devotionals', () {
      final a = DevotionalEngine.getForDate(DateTime(2026, 1, 1));
      final b = DevotionalEngine.getForDate(DateTime(2026, 1, 2));
      // Could theoretically be the same if library is small, but with 14 entries this works
      expect(a.reading.reference != b.reading.reference || a.title != b.title,
          true);
    });

    test('all devotionals have valid content', () {
      // Check a full year's worth
      for (int i = 0; i < 365; i++) {
        final date = DateTime(2026, 1, 1).add(Duration(days: i));
        final d = DevotionalEngine.getForDate(date);
        expect(d.reading.reference, isNotEmpty);
        expect(d.reading.text, isNotEmpty);
        expect(d.prompts, isNotEmpty);
      }
    });
  });

  group('Reading Plans', () {
    test('psalmsPlan has 30 days', () {
      final plan = DevotionalEngine.psalmsPlan;
      expect(plan.totalDays, 30);
      expect(plan.readings.length, 30);
      expect(plan.name, contains('Psalms'));
    });

    test('proverbs31Plan has 31 days', () {
      final plan = DevotionalEngine.proverbs31Plan;
      expect(plan.totalDays, 31);
      expect(plan.readings.length, 31);
    });

    test('gospelsPlan has 28 days', () {
      final plan = DevotionalEngine.gospelsPlan;
      expect(plan.totalDays, 28);
      expect(plan.readings.length, 28);
    });

    test('availablePlans returns all plans', () {
      final plans = DevotionalEngine.availablePlans;
      expect(plans.length, 3);
    });
  });
}
