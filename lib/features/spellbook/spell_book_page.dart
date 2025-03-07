import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/features/spellbook/spell_selection_page.dart';
import 'package:simple5e/features/spellbook/spell_slot_widget.dart';
import 'package:simple5e/models/spell.dart';
import 'package:simple5e/models/spell_slot.dart';
import 'package:simple5e/providers/providers.dart';
import 'package:expandable/expandable.dart';

class SpellbookPage extends ConsumerWidget {
  final int characterId;

  const SpellbookPage({
    super.key,
    required this.characterId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spellsAsyncValue = ref.watch(characterSpellsProvider(characterId));
    final spellSlotsAsyncValue =
        ref.watch(characterSpellSlotsProvider(characterId));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Spellbook'),
        centerTitle: true,
        elevation: 0,
      ),
      body: spellsAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('Error loading spells: $err')),
        data: (spells) => spellSlotsAsyncValue.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) =>
              Center(child: Text('Error loading spell slots: $err')),
          data: (spellSlots) =>
              _buildSpellbookContent(context, ref, spells, spellSlots),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToSpellSelection(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Spell'),
        elevation: 2,
      ),
    );
  }

  void _navigateToSpellSelection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpellSelectionPage(characterId: characterId),
      ),
    );
  }

  Widget _buildSpellbookContent(BuildContext context, WidgetRef ref,
      List<Spell> spells, List<SpellSlot> spellSlots) {
    final Map<int, List<Spell>> groupedSpells = {};

    for (var spell in spells) {
      final spellLevel = spell.level.toLowerCase().contains("cantrip")
          ? 0
          : int.parse(spell.level.replaceAll(RegExp(r'[^\d]'), ''));
      if (!groupedSpells.containsKey(spellLevel)) {
        groupedSpells[spellLevel] = [];
      }
      groupedSpells[spellLevel]!.add(spell);
    }

    final sortedLevels = groupedSpells.keys.toList()
      ..sort((a, b) {
        return a.compareTo(b);
      });

    if (spells.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .secondaryContainer
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                Icons.auto_stories,
                size: 64,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your spellbook is empty',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Start adding spells to your collection',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedLevels.length,
      itemBuilder: (context, index) {
        final level = sortedLevels[index];
        final levelSpells = groupedSpells[level]!;
        final spellSlot = spellSlots.firstWhere(
          (slot) => slot.level == level,
          orElse: () => SpellSlot(
            characterId: characterId,
            level: level,
            total: 0,
            used: 0,
            id: level,
          ),
        );

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .shadow
                    .withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: SpellSlotWidget(
                characterId: characterId,
                level: level,
                spellSlot: spellSlot,
              ),
              children: levelSpells.map((spell) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpandableNotifier(
                    child: ScrollOnExpand(
                      child: ExpandablePanel(
                        theme: ExpandableThemeData(
                          headerAlignment:
                              ExpandablePanelHeaderAlignment.center,
                          tapBodyToExpand: true,
                          tapBodyToCollapse: true,
                          hasIcon: false,
                          animationDuration: const Duration(milliseconds: 300),
                          bodyAlignment: ExpandablePanelBodyAlignment.left,
                        ),
                        header: ListTile(
                          title: Text(
                            spell.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          subtitle: Text(
                            '${spell.castingTime.replaceAll('*', '')} • ${spell.range.replaceAll('*', '')}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                          trailing: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 150),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ExpandableButton(
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Icon(
                                      Icons.expand_more,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        collapsed: const SizedBox(),
                        expanded: Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(height: 24),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer
                                      .withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    _buildDetailRow(context, 'Casting Time',
                                        spell.castingTime),
                                    _buildDetailRow(
                                        context, 'Range', spell.range),
                                    _buildDetailRow(context, 'Components',
                                        spell.components),
                                    _buildDetailRow(
                                        context, 'Duration', spell.duration),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildSection(
                                  context, 'Description', spell.description),
                              if (spell.additionalNotes?.isNotEmpty ?? false)
                                _buildSection(context, 'Additional Notes',
                                    spell.additionalNotes!),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        Theme.of(context).colorScheme.error,
                                  ),
                                  icon: const Icon(Icons.delete_outline),
                                  label: const Text('Remove'),
                                  onPressed: () {
                                    final removeSpell = ref
                                        .read(removeSpellProvider(characterId));
                                    removeSpell(spell.name);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.5,
              ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
