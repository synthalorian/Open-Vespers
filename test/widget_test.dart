import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vespers/widgets/scripture_page.dart';
import 'package:open_vespers/models/devotional.dart';
import 'package:open_vespers/theme/vespers_theme.dart';

void main() {
  group('ScripturePage', () {
    testWidgets('displays scripture text and reference', (tester) async {
      final devotional = DailyDevotional(
        date: DateTime.now(),
        title: 'Test Title',
        reading: const ScriptureReading(
          reference: 'John 3:16',
          text: 'For God so loved the world...',
        ),
        prayerFocus: 'Love',
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: VespersTheme.darkTheme,
          home: Scaffold(
            body: ScripturePage(devotional: devotional),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('For God so loved the world...'), findsOneWidget);
      expect(find.text('— John 3:16'), findsOneWidget);
      expect(find.text('CSB'), findsOneWidget);
    });

    testWidgets('shows swipe hint', (tester) async {
      final devotional = DailyDevotional(
        date: DateTime.now(),
        reading: const ScriptureReading(
          reference: 'Psalm 1:1',
          text: 'Blessed is the one...',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: VespersTheme.darkTheme,
          home: Scaffold(
            body: ScripturePage(devotional: devotional),
          ),
        ),
      );

      expect(find.text('Swipe to reflect'), findsOneWidget);
    });
  });
}
