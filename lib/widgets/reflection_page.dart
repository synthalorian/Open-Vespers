import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../theme/vespers_theme.dart';

class ReflectionPage extends ConsumerStatefulWidget {
  const ReflectionPage({super.key});

  @override
  ConsumerState<ReflectionPage> createState() => _ReflectionPageState();
}

class _ReflectionPageState extends ConsumerState<ReflectionPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(currentEntryProvider).reflectionText,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final devotional = ref.watch(todayDevotionalProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView(
        children: [
          const SizedBox(height: 20),
          const Text(
            'REFLECT',
            style: TextStyle(
              color: VespersTheme.warmGold,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ...devotional.prompts.map((prompt) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prompt.question,
                      style: const TextStyle(
                        color: VespersTheme.starlight,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (prompt.hint != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        prompt.hint!,
                        style: const TextStyle(
                          color: VespersTheme.textSecondary,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              )),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            maxLines: 8,
            style: const TextStyle(
              color: VespersTheme.textPrimary,
              fontSize: 15,
              height: 1.6,
            ),
            decoration: InputDecoration(
              hintText: 'Write your reflections...',
              hintStyle: const TextStyle(color: VespersTheme.textSecondary),
              filled: true,
              fillColor: VespersTheme.surfaceLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            onChanged: (v) {
              ref.read(currentEntryProvider.notifier).updateReflection(v);
            },
          ),
        ],
      ),
    );
  }
}
