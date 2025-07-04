import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/features/create_character/class_selection.dart';
import 'package:simple5e/features/create_character/race_selection.dart';
import 'package:simple5e/features/home/character_sheet_page.dart';
import 'package:simple5e/features/home/menu_drawer.dart';
import 'package:simple5e/models/character.dart';
import 'package:simple5e/providers/providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersAsyncValue = ref.watch(charactersProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Characters'),
        elevation: 0,
      ),
      drawer: const MenuDrawer(),
      body: _buildCharacterList(charactersAsyncValue, context, ref),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToRaceSelection(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCharacterList(AsyncValue<List<Character>> charactersAsyncValue,
      BuildContext context, WidgetRef ref) {
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
                  onLongPress: () => _showDeleteDialog(context, ref, character),
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

  void _showDeleteDialog(
      BuildContext context, WidgetRef ref, Character character) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete ${character.name}?'),
          content: const Text(
              'Are you sure you want to delete this character? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                ref
                    .read(charactersProvider.notifier)
                    .deleteCharacter(character.id);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
                ref.invalidate(currentClassPageProvider);
                ref.invalidate(currentPageProvider);
              },
            ),
          ],
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
      MaterialPageRoute(builder: (context) => RaceSelection()),
    ).then((_) => ref.refresh(charactersProvider));
  }
}
