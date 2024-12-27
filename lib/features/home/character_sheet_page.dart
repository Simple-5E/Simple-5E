import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:titan/features/spellbook/spell_book_page.dart';
import 'package:titan/features/stats/full_stats_page.dart';
import 'package:titan/models/spell.dart';
import 'package:titan/models/character.dart';
import 'package:titan/providers/providers.dart';
import 'diamond.dart';

class CharacterSheetPage extends ConsumerWidget {
  final int characterId;
  const CharacterSheetPage({
    Key? key,
    required this.characterId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spellsAsyncValue = ref.watch(characterSpellsProvider(characterId));
    final characterAsyncValue = ref.watch(characterProvider(characterId));

    return Scaffold(
      appBar: AppBar(
        title: characterAsyncValue.when(
          data: (character) => Text(character.name),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Error'),
        ),
      ),
      body: characterAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('Error loading character: $err')),
        data: (character) => spellsAsyncValue.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) =>
              Center(child: Text('Error loading spells: $err')),
          data: (spells) =>
              _buildCharacterSheet(context, ref, character, spells),
        ),
      ),
    );
  }

  Widget _buildCharacterSheet(BuildContext context, WidgetRef ref,
      Character character, List<Spell> spells) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeroImage(character),
          const SizedBox(height: 13),
          _buildCharacterStats(context, ref, character),
          const SizedBox(height: 13),
          _buildAbilityScores(context, ref, character),
          const Divider(color: Colors.grey, thickness: 1),
          _buildAdditionalInfo(context, ref, character),
          const SizedBox(height: 10),
          _buildActionButtons(context),
          const SizedBox(height: 10)
        ],
      ),
    );
  }

  Widget _buildHeroImage(Character character) {
    return Hero(
      tag: "dash${character.id}",
      child: AspectRatio(
        aspectRatio: 1920 / 1300,
        child: Image.asset(
          character.assetUri,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }

  Widget _buildCharacterStats(
      BuildContext context, WidgetRef ref, Character character) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildEditableDiamond(
              context, ref, 'Armor Class', character.armorClass.toString()),
          buildEditableDiamond(
              context, ref, 'Level', character.level.toString()),
          buildEditableDiamond(
              context, ref, 'Health Points', character.healthPoints.toString()),
        ],
      ),
    );
  }

  Widget buildEditableDiamond(
      BuildContext context, WidgetRef ref, String title, String value) {
    return InkWell(
      onTap: () => _showEditDialog(context, ref, title, value),
      child: buildDiamond(context, title.split(' ')[0], value),
    );
  }

  Widget _buildAbilityScores(
      BuildContext context, WidgetRef ref, Character character) {
    return Column(
      children: [
        buildEditableStatsRow(context, ref, [
          ['Initiative', character.initiative.toString()],
          ['Temporary', character.temporaryPoints.toString()],
          ['Speed', character.speed.toString()],
        ]),
        const Divider(color: Colors.grey, thickness: 1),
        buildEditableStatsRow(context, ref, [
          ['Strength', character.strength.toString()],
          ['Dexterity', character.dexterity.toString()],
          ['Constitution', character.constitution.toString()],
        ]),
        buildEditableStatsRow(context, ref, [
          ['Intelligence', character.intelligence.toString()],
          ['Wisdom', character.wisdom.toString()],
          ['Charisma', character.charisma.toString()],
        ]),
      ],
    );
  }

  Widget _buildAdditionalInfo(
      BuildContext context, WidgetRef ref, Character character) {
    return buildEditableStatsRow(context, ref, [
      ['Hit Dice', character.hitDice],
      ['Death Saves', character.deathSaves.toString()],
    ]);
  }

  Widget buildEditableStatsRow(
      BuildContext context, WidgetRef ref, List<List<String>> stats) {
    return Row(
      children: stats
          .map((stat) => buildEditableCard(context, ref, stat[0], stat[1]))
          .toList(),
    );
  }

  Widget buildEditableCard(
      BuildContext context, WidgetRef ref, String title, String value) {
    return Expanded(
      child: Card(
        child: InkWell(
          onTap: () => _showEditDialog(context, ref, title, value),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(value, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () => _navigateToSpellbook(context),
          child: const Text('Spell Book'),
        ),
        ElevatedButton(
          onPressed: () => _navigateToFullStats(context),
          child: const Text('Full Stats'),
        ),
      ],
    );
  }

  void _navigateToSpellbook(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpellbookPage(
          characterId: characterId,
        ),
      ),
    );
  }

  void _navigateToFullStats(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullStatsPage(characterId: characterId),
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, WidgetRef ref, String title, String currentValue) {
    int newValue = int.tryParse(currentValue) ?? 0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Edit $title'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        newValue--;
                      });
                    },
                  ),
                  Text(
                    newValue.toString(),
                    style: const TextStyle(fontSize: 24),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        newValue++;
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    ref.read(charactersProvider.notifier).updateCharacterStat(
                          characterId,
                          title,
                          newValue,
                        );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
