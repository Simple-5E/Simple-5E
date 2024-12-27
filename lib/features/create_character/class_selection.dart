// pages/class_selection.dart
import 'package:flutter/material.dart';
import 'package:titan/features/create_character/name_selection.dart';
import 'package:titan/models/race.dart';
import 'package:titan/models/character_class.dart';

class ClassSelection extends StatefulWidget {
  final Race selectedRace;

  const ClassSelection({super.key, required this.selectedRace});

  @override
  State<ClassSelection> createState() => _ClassSelectionState();
}

class _ClassSelectionState extends State<ClassSelection> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<CharacterClass> classes = [
    CharacterClass(
      name: 'Barbarian',
      description:
          'A fierce warrior who can enter a battle rage, channeling primal forces to enhance their combat abilities.',
      hitDie: 'd12',
      proficiencies: [
        'Light armor',
        'Medium armor',
        'Shields',
        'Simple weapons',
        'Martial weapons'
      ],
      spellcasting: 'None',
    ),
    CharacterClass(
      name: 'Bard',
      description:
          'An inspiring magician whose power echoes the music of creation, using their artistic talents to weave magic.',
      hitDie: 'd8',
      proficiencies: [
        'Light armor',
        'Simple weapons',
        'Hand crossbows',
        'Longswords',
        'Rapiers',
        'Shortswords',
        'Three musical instruments of your choice'
      ],
      spellcasting: 'Charisma-based spellcasting',
    ),
    CharacterClass(
      name: 'Cleric',
      description:
          'A priestly champion who wields divine magic in service of a higher power, channeling the power of their deity.',
      hitDie: 'd8',
      proficiencies: [
        'Light armor',
        'Medium armor',
        'Shields',
        'Simple weapons'
      ],
      spellcasting: 'Wisdom-based spellcasting',
    ),
    CharacterClass(
      name: 'Druid',
      description:
          'A priest of the Old Faith, wielding the powers of nature and adopting animal forms, protecting the natural world.',
      hitDie: 'd8',
      proficiencies: [
        'Light armor (nonmetal)',
        'Medium armor (nonmetal)',
        'Shields (nonmetal)',
        'Clubs',
        'Daggers',
        'Darts',
        'Javelins',
        'Maces',
        'Quarterstaffs',
        'Scimitars',
        'Sickles',
        'Slings',
        'Spears'
      ],
      spellcasting: 'Wisdom-based spellcasting',
    ),
    CharacterClass(
      name: 'Fighter',
      description:
          'A master of martial combat, skilled with a variety of weapons and armor, experts in the art of warfare.',
      hitDie: 'd10',
      proficiencies: [
        'All armor',
        'Shields',
        'Simple weapons',
        'Martial weapons'
      ],
      spellcasting:
          'None (some subclasses use Intelligence-based spellcasting)',
    ),
    CharacterClass(
      name: 'Monk',
      description:
          'A master of martial arts, harnessing the power of the body in pursuit of physical and spiritual perfection.',
      hitDie: 'd8',
      proficiencies: ['Simple weapons', 'Shortswords'],
      spellcasting: 'None',
    ),
    CharacterClass(
      name: 'Paladin',
      description:
          'A holy warrior bound to a sacred oath, combining martial prowess with divine spells and abilities.',
      hitDie: 'd10',
      proficiencies: [
        'All armor',
        'Shields',
        'Simple weapons',
        'Martial weapons'
      ],
      spellcasting: 'Charisma-based spellcasting',
    ),
    CharacterClass(
      name: 'Ranger',
      description:
          'A warrior who uses martial prowess and nature magic to combat threats on the edges of civilization.',
      hitDie: 'd10',
      proficiencies: [
        'Light armor',
        'Medium armor',
        'Shields',
        'Simple weapons',
        'Martial weapons'
      ],
      spellcasting: 'Wisdom-based spellcasting',
    ),
    CharacterClass(
      name: 'Rogue',
      description:
          'A scoundrel who uses stealth and trickery to overcome obstacles and enemies, masters of skill and precision.',
      hitDie: 'd8',
      proficiencies: [
        'Light armor',
        'Simple weapons',
        'Hand crossbows',
        'Longswords',
        'Rapiers',
        'Shortswords',
        'Thieves\' tools'
      ],
      spellcasting:
          'None (some subclasses use Intelligence-based spellcasting)',
    ),
    CharacterClass(
      name: 'Sorcerer',
      description:
          'A spellcaster who draws on inherent magic from a gift or bloodline, channeling raw magical power.',
      hitDie: 'd6',
      proficiencies: [
        'Daggers',
        'Darts',
        'Slings',
        'Quarterstaffs',
        'Light crossbows'
      ],
      spellcasting: 'Charisma-based spellcasting',
    ),
    CharacterClass(
      name: 'Warlock',
      description:
          'A wielder of magic that is derived from a bargain with an extraplanar entity, granted eldritch power.',
      hitDie: 'd8',
      proficiencies: ['Light armor', 'Simple weapons'],
      spellcasting: 'Charisma-based spellcasting with Pact Magic',
    ),
    CharacterClass(
      name: 'Wizard',
      description:
          'A scholarly magic-user capable of manipulating the structures of reality through careful study and mastery of arcane magic.',
      hitDie: 'd6',
      proficiencies: [
        'Daggers',
        'Darts',
        'Slings',
        'Quarterstaffs',
        'Light crossbows'
      ],
      spellcasting: 'Intelligence-based spellcasting',
    ),
  ];

  Widget _buildPageIndicator(int count, int current) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: current == index
                ? Theme.of(context).primaryColor
                : Colors.grey.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: classes.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final characterClass = classes[index];
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(characterClass.name,
                          style: TextStyle(
                              fontSize: 24,
                              color: Theme.of(context).colorScheme.onPrimary)),
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Class Image
                          Image.asset(
                            'assets/classes/${characterClass.name.toLowerCase()}.webp',
                            fit: BoxFit.cover,
                          ),
                          // Gradient overlay for better text visibility
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black54,
                                ],
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
                          // Selected Race Info
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.person),
                                const SizedBox(width: 8),
                                Text(
                                  'Selected Race: ${widget.selectedRace.name}',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Class Description
                          Text(
                            characterClass.description,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 24),

                          // Class Features
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Class Features',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 16),
                                _buildFeature('Hit Die', characterClass.hitDie),
                                _buildFeature(
                                  'Proficiencies',
                                  characterClass.proficiencies.join(', '),
                                ),
                                _buildFeature(
                                  'Spellcasting',
                                  characterClass.spellcasting,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          // Page Indicator
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: _buildPageIndicator(classes.length, currentPage),
          ),
          // Selection Button
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NameSelection(
                      selectedRace: widget.selectedRace,
                      selectedClass: classes[currentPage],
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Choose ${classes[currentPage].name}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }

  IconData _getClassIcon(String className) {
    switch (className.toLowerCase()) {
      case 'fighter':
        return Icons.shield;
      case 'wizard':
        return Icons.auto_fix_high;
      case 'rogue':
        return Icons.flash_on;
      default:
        return Icons.person;
    }
  }
}
