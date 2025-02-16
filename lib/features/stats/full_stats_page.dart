import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/features/create_character/classes.dart';
import 'package:simple5e/features/create_character/race_details.dart';
import 'package:simple5e/features/notes/notes_page.dart';
import 'package:simple5e/providers/custom_class_provider.dart';
import 'package:simple5e/providers/custom_race_provider.dart';
import '../../models/character.dart';
import '../../providers/providers.dart';
import 'dart:convert';
import '../../models/race.dart';
import '../../models/character_class.dart';
import 'package:simple5e/features/create_character/class_details.dart';

final currentImageIndexProvider = StateProvider<int>((ref) => 2);

class FullStatsPage extends ConsumerWidget {
  final int characterId;

  const FullStatsPage({super.key, required this.characterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var characterAsync = ref.watch(characterProvider(characterId));
    return characterAsync.when(
      data: (character) => _buildContent(context, ref, character),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }

  Widget _buildContent(
      BuildContext context, WidgetRef ref, Character character) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Stats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.note_add),
            tooltip: 'Character Notes',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotesPage(characterId: characterId),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            buildHeader(context, 'Character Details'),
            buildStatsRow(ref, [
              ['Name', character.name],
              ['Race', character.race],
              ['Class', character.characterClass],
            ]),
            buildStatsRow(
                ref,
                [
                  ['Armor Class', character.armorClass.toString()],
                  ['Initiative', character.initiative.toString()],
                  ['Speed', character.speed.toString()],
                ],
                editable: true),
            buildStatsRow(
                ref,
                [
                  ['Health Points', character.healthPoints.toString()],
                  ['Temporary Points', character.temporaryPoints.toString()],
                ],
                editable: true),
            buildHeader(context, 'Abilities'),
            buildStatsRow(
                ref,
                [
                  ['Strength', character.strength.toString()],
                  ['Dexterity', character.dexterity.toString()],
                  ['Constitution', character.constitution.toString()],
                ],
                editable: true,
                height: 70),
            buildStatsRow(
                ref,
                [
                  ['Intelligence', character.intelligence.toString()],
                  ['Wisdom', character.wisdom.toString()],
                  ['Charisma', character.charisma.toString()],
                ],
                editable: true,
                height: 70),
            buildHeader(context, 'Saving Throws'),
            buildStatsRow(
                ref,
                [
                  ['Strength Save', character.strSave.toString()],
                  ['Dexterity Save', character.dexSave.toString()],
                  ['Constitution Save', character.conSave.toString()],
                ],
                editable: true,
                height: 78),
            buildStatsRow(
                ref,
                [
                  ['Intelligence Save', character.intSave.toString()],
                  ['Wisdom Save', character.wisSave.toString()],
                  ['Charisma Save', character.chaSave.toString()],
                ],
                editable: true,
                height: 78),
            buildHeader(context, 'Skills'),
            buildStatsRow(
                ref,
                [
                  ['Acrobatics', character.acrobatics.toString()],
                  ['Animal Handling', character.animalHandling.toString()],
                  ['Arcana', character.arcana.toString()],
                ],
                editable: true,
                height: 78),
            buildStatsRow(
                ref,
                [
                  ['Athletics', character.athletics.toString()],
                  ['Deception', character.deception.toString()],
                  ['History', character.history.toString()],
                ],
                editable: true),
            buildStatsRow(
                ref,
                [
                  ['Insight', character.insight.toString()],
                  ['Intimidation', character.intimidation.toString()],
                  ['Investigation', character.investigation.toString()],
                ],
                editable: true),
            buildStatsRow(
                ref,
                [
                  ['Medicine', character.medicine.toString()],
                  ['Nature', character.nature.toString()],
                  ['Perception', character.perception.toString()],
                ],
                editable: true),
            buildStatsRow(
                ref,
                [
                  ['Performance', character.performance.toString()],
                  ['Persuasion', character.persuasion.toString()],
                  ['Religion', character.religion.toString()],
                ],
                editable: true),
            buildStatsRow(
                ref,
                [
                  ['Sleight of Hand', character.sleightOfHand.toString()],
                  ['Stealth', character.stealth.toString()],
                  ['Survival', character.survival.toString()],
                ],
                editable: true,
                height: 78),
            buildHeader(context, 'Other'),
            buildStatsRow(
                ref,
                [
                  ['Proficiency Bonus', character.proficiencyBonus.toString()],
                  ['Inspiration', character.inspiration.toString()],
                ],
                editable: true),
            buildStatsRow(
                ref,
                [
                  ['Hit Dice', character.hitDice],
                  ['Death Saves', character.deathSaves.toString()],
                ],
                editable: true),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }

  Widget buildStatsRow(WidgetRef ref, List<List<String>> stats,
      {bool editable = false, double height = 70}) {
    return Row(
      children: stats
          .map((stat) => buildCard(ref, stat[0], stat[1],
              editable: editable, height: height))
          .toList(),
    );
  }

  Widget buildCard(WidgetRef ref, String title, String value,
      {bool editable = false, double height = 70}) {
    return Expanded(
      child: Card(
        child: SizedBox(
            height: height,
            child: InkWell(
              onTap: () {
                if (editable) {
                  _showEditDialog(ref, title, value);
                } else if (title == 'Race') {
                  _showRaceDetails(ref.context, ref, value);
                } else if (title == 'Class') {
                  _showClassDetails(ref.context, ref, value);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Text(title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Text(value, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  void _showRaceDetails(
      BuildContext context, WidgetRef ref, String raceName) async {
    Race? race;

    final customRacesValue = ref.read(customRacesProvider);
    final customRaces = customRacesValue.when(
      data: (races) => races,
      loading: () => <Race>[],
      error: (_, __) => <Race>[],
    );

    try {
      race = customRaces
          .where((r) => r.name.toLowerCase() == raceName.toLowerCase())
          .firstOrNull;

      if (race == null) {
        final String jsonString = await DefaultAssetBundle.of(context)
            .loadString('assets/races/${raceName.toLowerCase()}.json');
        final Map<String, dynamic> jsonData = json.decode(jsonString);
        race = Race.fromJson(jsonData);
      }

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              body: RaceDetails(
                race: race!,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not load details for race: $raceName')),
        );
      }
    }
  }

  void _showClassDetails(
      BuildContext context, WidgetRef ref, String className) async {
    CharacterClass? characterClass;

    final customClassesValue = ref.read(customClassesProvider);
    final customClasses = customClassesValue.when(
      data: (classes) => classes,
      loading: () => <CharacterClass>[],
      error: (_, __) => <CharacterClass>[],
    );

    try {
      characterClass = customClasses
          .where((c) => c.name.toLowerCase() == className.toLowerCase())
          .firstOrNull;

      characterClass ??= classes.firstWhere(
        (c) => c.name.toLowerCase() == className.toLowerCase(),
        orElse: () => throw Exception('Class not found'),
      );

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              body: ClassDetails(
                characterClass: characterClass!,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Could not load details for class: $className')),
        );
      }
    }
  }

  void _showEditDialog(WidgetRef ref, String title, String currentValue) {
    if (title == 'Hit Dice') {
      _showHitDiceEditDialog(ref, currentValue);
    } else {
      _showNumericEditDialog(ref, title, currentValue);
    }
  }

  void _showHitDiceEditDialog(WidgetRef ref, String currentValue) {
    String newValue = currentValue;
    showDialog(
      context: ref.context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Hit Dice'),
          content: TextField(
            decoration: InputDecoration(hintText: 'e.g., 1d8, 2d6'),
            controller: TextEditingController(text: currentValue),
            onChanged: (value) {
              newValue = value;
            },
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
                      'Hit Dice',
                      newValue,
                    );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showNumericEditDialog(
      WidgetRef ref, String title, String currentValue) {
    if (title == 'Health Points') {
      final textController = TextEditingController(text: currentValue);
      showDialog(
        context: ref.context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit $title'),
            content: TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter HP value',
              ),
              autofocus: true,
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  final newValue = int.tryParse(textController.text) ?? 0;
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
      return;
    }

    int newValue = int.tryParse(currentValue) ?? 0;
    showDialog(
      context: ref.context,
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
