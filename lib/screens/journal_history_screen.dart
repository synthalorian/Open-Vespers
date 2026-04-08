import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../theme/vespers_theme.dart';

class JournalHistoryScreen extends ConsumerWidget {
  const JournalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(journalEntriesProvider);
    final streak = ref.watch(streakProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'JOURNAL',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),
        centerTitle: true,
      ),
      body: entries.isEmpty
          ? _emptyState()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Stats bar
                Row(
                  children: [
                    _statCard('Entries', '${entries.length}', Icons.edit_note),
                    const SizedBox(width: 12),
                    _statCard('Streak', '$streak day${streak == 1 ? '' : 's'}',
                        Icons.local_fire_department),
                  ],
                ),
                const SizedBox(height: 20),
                // Entries
                ...entries.map((entry) {
                  final hasReflection = entry.reflectionText.isNotEmpty;
                  final hasPrayer = entry.prayerText.isNotEmpty;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: VespersTheme.warmGold.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '${entry.date.day}',
                            style: const TextStyle(
                              color: VespersTheme.warmGold,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        entry.scriptureReference.isNotEmpty
                            ? entry.scriptureReference
                            : _formatDate(entry.date),
                        style: const TextStyle(
                          color: VespersTheme.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        _formatDate(entry.date),
                        style: const TextStyle(
                          color: VespersTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (hasReflection)
                            const Icon(Icons.edit,
                                size: 14, color: VespersTheme.starlight),
                          if (hasPrayer) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.volunteer_activism,
                                size: 14, color: VespersTheme.warmGold),
                          ],
                        ],
                      ),
                      children: [
                        if (hasReflection) ...[
                          _section('Reflection', entry.reflectionText),
                          const SizedBox(height: 12),
                        ],
                        if (hasPrayer) _section('Prayer', entry.prayerText),
                      ],
                    ),
                  );
                }),
              ],
            ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.book_outlined, color: VespersTheme.textSecondary, size: 48),
          SizedBox(height: 12),
          Text(
            'No journal entries yet',
            style: TextStyle(color: VespersTheme.textPrimary, fontSize: 16),
          ),
          SizedBox(height: 4),
          Text(
            'Your reflections and prayers will appear here',
            style: TextStyle(color: VespersTheme.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(icon, color: VespersTheme.warmGold, size: 20),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: VespersTheme.warmGold,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                      color: VespersTheme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(String title, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: VespersTheme.warmGold,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          text,
          style: const TextStyle(
            color: VespersTheme.textPrimary,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}
