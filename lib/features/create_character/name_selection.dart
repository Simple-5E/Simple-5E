import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/data/character_repository.dart';
import 'package:simple5e/features/home/home_page.dart';
import 'package:simple5e/models/character.dart';
import 'package:simple5e/models/race.dart';
import 'package:simple5e/models/character_class.dart';
import 'package:simple5e/providers/providers.dart';
import 'package:simple5e/widgets/class_image_widget.dart';
import 'package:flutter/services.dart' show rootBundle;

class NameSelectionState {
  final String name;
  final bool isValid;
  final bool isSaving;

  const NameSelectionState({
    this.name = '',
    this.isValid = false,
    this.isSaving = false,
  });

  NameSelectionState copyWith({
    String? name,
    bool? isValid,
    bool? isSaving,
  }) {
    return NameSelectionState(
      name: name ?? this.name,
      isValid: isValid ?? this.isValid,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

final nameSelectionStateProvider = StateNotifierProvider.autoDispose<
    NameSelectionNotifier, NameSelectionState>((ref) {
  return NameSelectionNotifier();
});

class NameSelectionNotifier extends StateNotifier<NameSelectionState> {
  NameSelectionNotifier() : super(const NameSelectionState());

  void updateName(String name) {
    state = state.copyWith(
      name: name,
      isValid: name.trim().length >= 2,
    );
  }

  void setSaving(bool saving) {
    state = state.copyWith(isSaving: saving);
  }
}

class NameSelection extends ConsumerWidget {
  final Race selectedRace;
  final CharacterClass selectedClass;
  final TextEditingController _nameController = TextEditingController();
  final CharacterRepository _characterRepository = CharacterRepository.instance;

  NameSelection({
    super.key,
    required this.selectedRace,
    required this.selectedClass,
  });

  Future<void> _saveCharacter(WidgetRef ref, BuildContext context) async {
    final state = ref.read(nameSelectionStateProvider);
    if (!state.isValid) return;

    final notifier = ref.read(nameSelectionStateProvider.notifier);
    notifier.setSaving(true);

    try {
      final id = await _characterRepository.getNextCharacterId();

      final classAssetExists = await _checkAssetExists(
        'assets/classes/${selectedClass.name.toLowerCase()}.webp',
      );

      final assetUri = classAssetExists
          ? 'assets/classes/${selectedClass.name.toLowerCase()}.webp'
          : 'assets/classes/custom.webp';

      final character = Character(
        id: id,
        level: 1,
        name: state.name.trim(),
        race: selectedRace.name,
        characterClass: selectedClass.name,
        armorClass: _getInitialArmorClass(),
        initiative: 0,
        speed: int.parse(selectedRace.speed.replaceAll(RegExp(r'[^0-9]'), '')),
        healthPoints: _getInitialHP(),
        temporaryPoints: 0,
        strength: 10,
        dexterity: 10,
        constitution: 10,
        intelligence: 10,
        wisdom: 10,
        charisma: 10,
        hitDice: '1${selectedClass.hitDie}',
        deathSaves: 0,
        dexSave: 0,
        strSave: 0,
        conSave: 0,
        deception: 0,
        intSave: 0,
        wisSave: 0,
        chaSave: 0,
        proficiencyBonus: 2,
        inspiration: 0,
        acrobatics: 0,
        sleightOfHand: 0,
        stealth: 0,
        animalHandling: 0,
        insight: 0,
        medicine: 0,
        perception: 0,
        survival: 0,
        athletics: 0,
        intimidation: 0,
        performance: 0,
        persuasion: 0,
        arcana: 0,
        history: 0,
        investigation: 0,
        nature: 0,
        religion: 0,
        assetUri: assetUri,
      );

      await _characterRepository.createCharacter(character);
      ref.invalidate(charactersProvider);

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create character. Please try again.'),
          ),
        );
      }
    } finally {
      notifier.setSaving(false);
    }
  }

  int _getInitialHP() {
    final hitDieValue = int.parse(selectedClass.hitDie.substring(1));
    return hitDieValue;
  }

  int _getInitialArmorClass() {
    if (selectedClass.proficiencies.contains('All armor') ||
        selectedClass.proficiencies.contains('Medium armor')) {
      return 14;
    } else if (selectedClass.proficiencies.contains('Light armor')) {
      return 11;
    }
    return 10;
  }

  List<String> _getNameSuggestions() {
    switch (selectedRace.name.toLowerCase()) {
      case 'dragonborn':
        return [
          'Rhogar Clethinthiallor',
          'Bharash Delmirev',
          'Verthisath Tumembor',
          'Akra Myastan',
          'Kalas Nemmonis',
          'Patrin Daardendrian',
          'Torinn Kerkad',
          'Heskan Ghequur',
          'Narinda Yarjerit',
          'Medrash Shesintor'
        ];
      case 'dwarf':
        return [
          'Thorin Ironfist',
          'Durgath Stonefist',
          'Morik Hammersong',
          'Brunhild Goldweaver',
          'Kildrak Battleforge',
          'Barendd Rockseeker',
          'Dagnal Ungart',
          'Tordek Frostbeard',
          'Gardain Deepdelver',
          'Rurik Balderk'
        ];
      case 'elf':
        return [
          'Aelindra Galanodel',
          'Caelynn Amakiir',
          'Thrandil Liadon',
          'Galador Meliamne',
          'Variel Xiloscient',
          'Aerandril Siannodel',
          'Erevan Holimion',
          'Quildenna Silverfrond',
          'Soveliss Starweaver',
          'Laucian Moonwhisper'
        ];
      case 'gnome':
        return [
          'Nix Beren',
          'Boddynock Glittergem',
          'Roondar Timbers',
          'Zanna Ningel',
          'Wrenn Folkor',
          'Alston Tealeaf',
          'Dimble Nackle',
          'Warryn Scheppen',
          'Murnig Garrick',
          'Burgell Brightgleam'
        ];
      case 'half-elf':
        return [
          'Arlen Winterfall',
          'Sarai Gladewind',
          'Thalion Moonglow',
          'Kyra Stormwind',
          'Valdor Shadowweave',
          'Silas Halfborn',
          'Althaea Duskwalker',
          'Corlinn Evenbreeze',
          'Pyrran Swiftshadow',
          'Tessia Dawncaller'
        ];
      case 'halfling':
        return [
          'Bilbo Baggins',
          'Meriadoc Brandybuck',
          'Rosie Cotton',
          'Pippin Took',
          'Frodo Underhill',
          'Corrin Tealeaf',
          'Garret Goodbarrel',
          'Milo Brushgather',
          'Wendell Underbough',
          'Andry Thorngage'
        ];
      case 'half-orc':
        return [
          'Grok Bearfist',
          'Thokk Skullcrusher',
          'Umara Bonegrinder',
          'Krusk Steelfang',
          'Shaga Doomfist',
          'Keth Bloodtusk',
          'Morgha Ironfist',
          'Grommash Warcry',
          'Rendar Battleborn',
          'Zorka Thundermaul'
        ];
      case 'human':
        return [
          'Arthur Pendragon',
          'Elena Blackwood',
          'Marcus Aurelius',
          'Isabella Valencia',
          'Richard Hawthorne',
          'William Thorne',
          'Sophia Constantine',
          'James Ironwood',
          'Catherine Blackbriar',
          'Alexander Storm'
        ];
      case 'tiefling':
        return [
          'Ash Shadowweaver',
          'Orianna Duskwalker',
          'Mephistopheles Nightshade',
          'Lilith Thornheart',
          'Zariel Blackfire',
          'Crimson Flamebrand',
          'Thistle Darkhope',
          'Raven Cruelshadow',
          'Morthos Dreadweaver',
          'Tempest Hellborn'
        ];
      default:
        return [];
    }
  }

  Future<bool> _checkAssetExists(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nameSelectionStateProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  ClassImageWidget(
                    className: selectedClass.name,
                    fit: BoxFit.cover,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person),
                            const SizedBox(width: 8),
                            Text(
                              'Selected Race: ${selectedRace.name}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.security),
                            const SizedBox(width: 8),
                            Text(
                              'Selected Class: ${selectedClass.name}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'What is your character\'s name?',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose a name that fits your character\'s personality and background.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _nameController,
                    onChanged: (value) {
                      ref
                          .read(nameSelectionStateProvider.notifier)
                          .updateName(value);
                    },
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Character Name',
                      hintText: 'Enter your character\'s name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.edit),
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (_getNameSuggestions().isNotEmpty) ...[
                    Text(
                      'Popular ${selectedRace.name} Names:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _getNameSuggestions()
                          .map((name) => ActionChip(
                                label: Text(name),
                                onPressed: () {
                                  _nameController.text = name;
                                  ref
                                      .read(nameSelectionStateProvider.notifier)
                                      .updateName(name);
                                },
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: state.isValid ? () => _saveCharacter(ref, context) : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: state.isSaving
              ? const CircularProgressIndicator()
              : const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
