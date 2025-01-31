import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/features/spellbook/custom_spell_form.dart';
import 'package:simple5e/models/spell.dart';
import 'package:simple5e/providers/spell_provider.dart';
import 'package:expandable/expandable.dart';

class ManageCustomSpellsPage extends ConsumerWidget {
  const ManageCustomSpellsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customSpellsAsyncValue = ref.watch(userDefinedSpellsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Custom Spells'),
      ),
      body: customSpellsAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (spells) {
          if (spells.isEmpty) {
            return const Center(child: Text('No custom spells found.'));
          }
          return ListView.builder(
            itemCount: spells.length,
            itemBuilder: (context, index) {
              final spell = spells[index];
              return _buildSpellCard(context, ref, spell);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addSpell(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSpellCard(BuildContext context, WidgetRef ref, Spell spell) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpandableNotifier(
        child: ScrollOnExpand(
          child: ExpandablePanel(
            theme: const ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              tapBodyToExpand: true,
              tapBodyToCollapse: true,
              hasIcon: false,
            ),
            header: ListTile(
              title: Text(
                spell.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: Text(
                '${spell.level} • ${spell.castingTime}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteSpell(context, ref, spell),
                  ),
                  ExpandableButton(
                    child: const Icon(Icons.expand_more),
                  ),
                ],
              ),
            ),
            collapsed: const SizedBox(),
            expanded: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  _buildDetailRow('Casting Time', spell.castingTime),
                  _buildDetailRow('Range', spell.range),
                  _buildDetailRow('Components', spell.components),
                  _buildDetailRow('Duration', spell.duration),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(spell.description),
                  if (spell.additionalNotes != null &&
                      spell.additionalNotes!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Additional Notes',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(spell.additionalNotes!),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _deleteSpell(BuildContext context, WidgetRef ref, Spell spell) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Spell'),
        content: Text('Are you sure you want to delete ${spell.name}?'),
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
          .read(userDefinedSpellsProvider.notifier)
          .deleteSpell(spell.name);
    }
  }

  void _addSpell(BuildContext context, WidgetRef ref) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: CustomSpellForm(
            onSpellCreated: (Spell newSpell) {
              ref.read(userDefinedSpellsProvider.notifier).addSpell(newSpell);
            },
          ),
        ),
      ),
    );
  }
}
