import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/theme/dark.dart';
import 'package:simple5e/theme/light.dart';
import 'package:simple5e/theme/theme_provider.dart';
import 'package:simple5e/features/home/home_page.dart';
import 'package:simple5e/data/database_init.dart';
import 'package:simple5e/features/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      title: 'Simple 5e',
      theme: light,
      darkTheme: dark,
      themeAnimationDuration: const Duration(milliseconds: 200),
      home: FutureBuilder(
        future: DatabaseInitializer.instance.initializeDatabase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const HomePage();
          } else {
            return const SplashScreen();
          }
        },
      ),
    );
  }
}
