import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/journal_repository.dart';
import 'theme/vespers_theme.dart';
import 'screens/devotional_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JournalRepository.init();
  runApp(const ProviderScope(child: VespersApp()));
}

class VespersApp extends StatelessWidget {
  const VespersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vespers',
      debugShowCheckedModeBanner: false,
      theme: VespersTheme.darkTheme,
      home: const DevotionalScreen(),
    );
  }
}
