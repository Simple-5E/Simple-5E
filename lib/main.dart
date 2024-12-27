import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:titan/theme/dark.dart';
import 'package:titan/theme/light.dart';
import 'package:titan/theme/theme_provider.dart';
import 'package:titan/features/home/home_page.dart';
import 'package:titan/data/database_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseInitializer.instance.initializeDatabase();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return MaterialApp(
      themeMode: themeMode,
      title: 'Simple 5e',
      theme: light,
      darkTheme: dark,
      home: HomePage(),
    );
  }
}
