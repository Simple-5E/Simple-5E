import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:titan/features/create_character/race_selection.dart';
import 'package:titan/features/home/character_sheet_page.dart';
import 'package:titan/models/character.dart';
import 'package:titan/providers/providers.dart';
import 'package:titan/theme/theme_provider.dart';
import 'dart:io';
import 'package:titan/data/character_repository.dart';
import 'package:titan/data/spell_repository.dart';
import 'package:titan/data/spell_slot_repository.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersAsyncValue = ref.watch(charactersProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Characters'),
        elevation: 0,
      ),
      drawer: _buildDrawer(context, ref),
      body: _buildCharacterList(charactersAsyncValue, context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToRaceSelection(context, ref),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildCharacterList(
      AsyncValue<List<Character>> charactersAsyncValue, BuildContext context) {
    return charactersAsyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (characters) {
        if (characters.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 200),
                Icon(
                  Icons.person_add_rounded,
                  size: 64,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'No characters yet',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the + button to create your first character!',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: characters.length,
          itemBuilder: (context, index) {
            final character = characters[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                elevation: 3,
                child: InkWell(
                  onTap: () => _navigateToCharacterSheet(context, character),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Hero(
                          tag: 'character-${character.id}',
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(character.assetUri),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                character.name,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${character.race} ${character.characterClass}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Level ${character.level}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToCharacterSheet(BuildContext context, Character character) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CharacterSheetPage(characterId: character.id),
      ),
    );
  }

  void _navigateToRaceSelection(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RaceSelection()),
    ).then((_) => ref.refresh(charactersProvider));
  }

  Widget _buildDrawer(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 24,
              ),
            ),
          ),
          _buildThemeSelector(ref),
          _buildResetDataTile(context),
        ],
      ),
    );
  }

  Widget _buildThemeSelector(WidgetRef ref) {
    return Consumer(builder: (context, watch, child) {
      final themeMode = ref.watch(themeProvider);
      return ListTile(
        leading: const Icon(Icons.palette),
        title: const Text('Theme'),
        trailing: DropdownButton<ThemeMode>(
          value: themeMode,
          onChanged: (ThemeMode? newValue) {
            ref.read(themeProvider.notifier).state = newValue!;
          },
          items: ThemeMode.values
              .map<DropdownMenuItem<ThemeMode>>((ThemeMode value) {
            return DropdownMenuItem<ThemeMode>(
              value: value,
              child: Text(value.toString().split('.').last),
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _buildResetDataTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.restore),
      title: const Text('Reset Data'),
      onTap: () async {
        await _showResetConfirmationDialog(context);
      },
    );
  }

  Future<void> _showResetConfirmationDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Reset'),
          content: const Text(
              'Are you sure you want to reset all data? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Reset'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await SpellSlotRepository.instance.clearDB();
      await SpellRepository.instance.clearDB();
      await CharacterRepository.instance.clearDB();
      exit(0);
    }
  }
}
