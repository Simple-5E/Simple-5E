import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/features/create_character/custom_race_form.dart';
import 'package:simple5e/models/race.dart';
import 'package:simple5e/features/create_character/race_details.dart';
import 'package:simple5e/providers/custom_race_provider.dart';

class ManageCustomRacesPage extends ConsumerWidget {
  const ManageCustomRacesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customRacesAsyncValue = ref.watch(customRacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Custom Races'),
      ),
      body: customRacesAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (races) {
          if (races.isEmpty) {
            return const Center(child: Text('No custom races found.'));
          }
          return ListView.builder(
            itemCount: races.length,
            itemBuilder: (context, index) {
              final race = races[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: InkWell(
                  onTap: () => _editRace(context, race),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              race.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteRace(context, ref, race),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          race.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            _buildChip('Size: ${race.size}'),
                            _buildChip('Speed: ${race.speed}'),
                            _buildChip(race.abilityScoreIncrease),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewRace(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    );
  }

  void _deleteRace(BuildContext context, WidgetRef ref, Race race) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Race'),
        content: Text('Are you sure you want to delete ${race.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(customRacesProvider.notifier).deleteCustomRace(race.name);
    }
  }

  void _editRace(BuildContext context, Race race) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(body: RaceDetails(race: race)),
      ),
    );
  }

  void _addNewRace(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(body: CustomRaceForm()),
      ),
    );
  }
}
