import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.light; // false represents light theme, true for dark
});

class ThemeTogglePage extends ConsumerWidget {
  const ThemeTogglePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeMode = ref.watch(themeProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Toggle'),
      ),
      body: Center(
        child: DropdownButton<ThemeMode>(
          value: themeMode,
          items: const <DropdownMenuItem<ThemeMode>>[
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Text('System'),
            ),
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Text('Light'),
            ),
            DropdownMenuItem(
              value: ThemeMode.dark,
              child: Text('Dark'),
            ),
          ],
          onChanged: (newValue) {
            if (newValue != null) {
              ref.read(themeProvider.notifier).state = newValue;
            }
          },
        ),
      ),
    );
  }
}
