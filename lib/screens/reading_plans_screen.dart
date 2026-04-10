import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/devotional.dart';
import '../providers/providers.dart';
import '../theme/vespers_theme.dart';

class ReadingPlansScreen extends ConsumerWidget {
  const ReadingPlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(availablePlansProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'READING PLANS',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Choose a reading plan to guide your daily study.',
              style: TextStyle(
                color: VespersTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          ...plans.map((plan) => _PlanCard(plan: plan)),
        ],
      ),
    );
  }
}

class _PlanCard extends ConsumerWidget {
  final ReadingPlan plan;

  const _PlanCard({required this.plan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: VespersTheme.warmGold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.menu_book,
                    color: VespersTheme.warmGold,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: const TextStyle(
                          color: VespersTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${plan.totalDays} days',
                        style: const TextStyle(
                          color: VespersTheme.warmGold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (plan.description != null) ...[
              const SizedBox(height: 10),
              Text(
                plan.description!,
                style: const TextStyle(
                  color: VespersTheme.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
            const SizedBox(height: 12),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: plan.progress,
                minHeight: 6,
                backgroundColor: VespersTheme.surfaceLight,
                valueColor: const AlwaysStoppedAnimation<Color>(
                    VespersTheme.warmGold),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  plan.isComplete
                      ? 'Completed!'
                      : 'Day ${plan.currentDay} of ${plan.totalDays}',
                  style: const TextStyle(
                    color: VespersTheme.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                Text(
                  '${(plan.progress * 100).round()}%',
                  style: const TextStyle(
                    color: VespersTheme.warmGold,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (plan.todayReading != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: VespersTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'TODAY\'S READING',
                            style: TextStyle(
                              color: VespersTheme.warmGold,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            plan.todayReading!.reference,
                            style: const TextStyle(
                              color: VespersTheme.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(availablePlansProvider.notifier)
                            .incrementDay(plan.id);
                      },
                      icon: const Icon(
                        Icons.check_circle_outline,
                        color: VespersTheme.warmGold,
                      ),
                      tooltip: 'Mark Complete',
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
