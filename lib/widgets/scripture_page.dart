import 'package:flutter/material.dart';
import '../models/devotional.dart';
import '../theme/vespers_theme.dart';

class ScripturePage extends StatelessWidget {
  final DailyDevotional devotional;

  const ScripturePage({super.key, required this.devotional});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (devotional.title != null) ...[
            Text(
              devotional.title!,
              style: const TextStyle(
                color: VespersTheme.softAmber,
                fontSize: 14,
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
          ],
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: VespersTheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: VespersTheme.warmGold.withOpacity(0.15),
              ),
            ),
            child: Column(
              children: [
                Text(
                  devotional.reading.text,
                  style: const TextStyle(
                    color: VespersTheme.textPrimary,
                    fontSize: 22,
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  '— ${devotional.reading.reference}',
                  style: const TextStyle(
                    color: VespersTheme.warmGold,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (devotional.reading.translation != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    devotional.reading.translation!,
                    style: const TextStyle(
                      color: VespersTheme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.swipe, color: VespersTheme.textSecondary, size: 16),
              SizedBox(width: 6),
              Text(
                'Swipe to reflect',
                style: TextStyle(
                  color: VespersTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
