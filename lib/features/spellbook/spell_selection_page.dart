import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/models/spell.dart';
import 'package:simple5e/providers/providers.dart';
import 'package:simple5e/data/spell_repository.dart';
import 'package:expandable/expandable.dart';
import 'package:simple5e/features/spellbook/custom_spell_form.dart';

class SpellSelectionPage extends ConsumerStatefulWidget {
  final int characterId;

  const SpellSelectionPage({
    super.key,
    required this.characterId,
  });

  @override
  ConsumerState<SpellSelectionPage> createState() => _SpellSelectionPageState();
}

class _SpellSelectionPageState extends ConsumerState<SpellSelectionPage> {
  String? selectedClass;
  final TextEditingController _searchController = TextEditingController();
  List<Spell> filteredSpells = [];
  List<Spell> allSpells = [];
  int? expandedIndex;

  @override
  void initState() {
    super.initState();
    _loadSpells();
  }

  Future<void> _loadSpells() async {
    final spells = await SpellRepository.instance.readAllSpells();
    setState(() {
      allSpells = spells;
      filteredSpells = List.from(spells);
      _filterSpells();
    });
  }

  void _filterSpells() {
    setState(() {
      filteredSpells = allSpells.where((spell) {
        final matchesSearch = spell.name
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
        final matchesClass =
            selectedClass == null || spell.classes.contains(selectedClass);
        return matchesSearch && matchesClass;
      }).toList();

      filteredSpells.sort((a, b) {
        if (a.level.toLowerCase().contains('cantrip')) return -1;
        if (b.level.toLowerCase().contains('cantrip')) return 1;

        final levelA = int.parse(a.level.replaceAll(RegExp(r'[^\d]'), ''));
        final levelB = int.parse(b.level.replaceAll(RegExp(r'[^\d]'), ''));

        final levelCompare = levelA.compareTo(levelB);
        if (levelCompare != 0) return levelCompare;

        return a.name.compareTo(b.name);
      });
    });
  }

  Widget _buildSpellCard(Spell spell, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpandableNotifier(
        child: ScrollOnExpand(
          child: ExpandablePanel(
            theme: const ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              tapBodyToExpand: true,
              tapBodyToCollapse: true,
              hasIcon: false,
              animationDuration: Duration(milliseconds: 300),
            ),
            header: ListTile(
              title: Text(
                spell.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                '${spell.level} • ${spell.classes.join(", ")}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      try {
                        final spellRepo = SpellRepository.instance;
                        final characterSpells = await spellRepo
                            .readSpellsForCharacter(widget.characterId);

                        if (characterSpells.any((s) => s.name == spell.name)) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${spell.name} is already in spellbook'),
                                duration: const Duration(seconds: 2),
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                              ),
                            );
                          }
                          return;
                        }

                        final addSpell =
                            ref.read(addSpellProvider(widget.characterId));
                        await addSpell(spell);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${spell.name} added to spellbook'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Error adding spell: ${e.toString()}'),
                              duration: const Duration(seconds: 2),
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ),
                          );
                        }
                      }
                    },
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
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondaryContainer
                          .withAlpha(77),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow('Casting Time', spell.castingTime),
                        _buildDetailRow('Range', spell.range),
                        _buildDetailRow('Components', spell.components),
                        _buildDetailRow('Duration', spell.duration),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(spell.description),
                  if (spell.additionalNotes != null &&
                      spell.additionalNotes!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Additional Notes',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
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
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableClasses =
        allSpells.expand((spell) => spell.classes).toSet().toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Spells'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CustomSpellForm(
                    onSpellCreated: (Spell newSpell) {
                      setState(() {
                        allSpells.add(newSpell);
                        _filterSpells();
                      });
                    },
                  ),
                ),
              );
            },
            tooltip: 'Create Custom Spell',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search spells...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  onChanged: (_) => _filterSpells(),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: const Text('All Classes'),
                          selected: selectedClass == null,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedClass = null;
                              _filterSpells();
                            });
                          },
                        ),
                      ),
                      ...availableClasses.map((className) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(className),
                            selected: selectedClass == className,
                            onSelected: (bool selected) {
                              setState(() {
                                selectedClass = selected ? className : null;
                                _filterSpells();
                              });
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredSpells.length,
        itemBuilder: (context, index) {
          final spell = filteredSpells[index];
          return _buildSpellCard(spell, index);
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
