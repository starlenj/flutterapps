import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // Isar'ı veya binding'i burada hazırlamak istersen:
  // WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: StashMarkApp()));
}

class StashMarkApp extends StatelessWidget {
  const StashMarkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StashMark',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(body: Center(child: Text('StashMark'))),
    );
  }
}
