import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../theme/vespers_theme.dart';
import '../widgets/scripture_page.dart';
import '../widgets/reflection_page.dart';
import '../widgets/prayer_page.dart';
import 'journal_history_screen.dart';
import 'reading_plans_screen.dart';

class DevotionalScreen extends ConsumerStatefulWidget {
  const DevotionalScreen({super.key});

  @override
  ConsumerState<DevotionalScreen> createState() => _DevotionalScreenState();
}

class _DevotionalScreenState extends ConsumerState<DevotionalScreen> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final devotional = ref.watch(todayDevotionalProvider);
    final streak = ref.watch(streakProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
              child: Row(
                children: [
                  const Text(
                    'VESPERS',
                    style: TextStyle(
                      color: VespersTheme.warmGold,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                  if (streak > 0) ...[
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: VespersTheme.warmGold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$streak day${streak == 1 ? '' : 's'}',
                        style: const TextStyle(
                          color: VespersTheme.warmGold,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Text(
                    _formatDate(DateTime.now()),
                    style: const TextStyle(
                      color: VespersTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu_book_rounded, size: 20),
                    color: VespersTheme.textSecondary,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ReadingPlansScreen()),
                    ),
                    tooltip: 'Reading Plans',
                  ),
                  IconButton(
                    icon: const Icon(Icons.book, size: 20),
                    color: VespersTheme.textSecondary,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const JournalHistoryScreen()),
                    ),
                    tooltip: 'Journal History',
                  ),
                ],
              ),
            ),
            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return Container(
                    width: i == _currentPage ? 24 : 8,
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: i == _currentPage
                          ? VespersTheme.warmGold
                          : VespersTheme.deepBlue,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ),
            ),
            // Pages
            Expanded(
              child: PageView(
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  ScripturePage(devotional: devotional),
                  const ReflectionPage(),
                  const PrayerPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}
