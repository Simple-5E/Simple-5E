// lib/features/manage_data/manage_custom_classes.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/features/create_character/custom_class_form.dart';
import 'package:simple5e/models/character_class.dart';
import 'package:simple5e/features/create_character/class_details.dart';
import 'package:simple5e/providers/custom_class_provider.dart';

class ManageCustomClassesPage extends ConsumerWidget {
  const ManageCustomClassesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customClassesAsyncValue = ref.watch(customClassesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Custom Classes'),
      ),
      body: customClassesAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (classes) {
          if (classes.isEmpty) {
            return const Center(child: Text('No custom classes found.'));
          }
          return ListView.builder(
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final characterClass = classes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: InkWell(
                  onTap: () => _editClass(context, characterClass),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              characterClass.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteClass(context, ref, characterClass),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          characterClass.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
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
        onPressed: () => _addClass(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _deleteClass(BuildContext context, WidgetRef ref,
      CharacterClass characterClass) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Class'),
        content:
            Text('Are you sure you want to delete ${characterClass.name}?'),
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
      await ref
          .read(customClassesProvider.notifier)
          .deleteCustomClass(characterClass.name);
    }
  }

  void _editClass(BuildContext context, CharacterClass characterClass) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            Scaffold(body: ClassDetails(characterClass: characterClass)),
      ),
    );
  }

  void _addClass(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(body: CustomClassForm()),
      ),
    );
  }
}
