import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/Core/Router/app_router.dart';
import 'package:todoapp/Core/database/isar_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  try {
    await IsarService().init();
  } catch (e) {
    debugPrint('Warning: Isar init failed : $e');
  }
  runApp(const ProviderScope(child: StashMarkApp()));
}

class StashMarkApp extends ConsumerWidget {
  const StashMarkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'StashMark',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1)),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
