import 'package:simple5e/models/character_class.dart';

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
    proficiencies: ['Light armor', 'Medium armor', 'Shields', 'Simple weapons'],
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
    spellcasting: 'None (some subclasses use Intelligence-based spellcasting)',
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
    spellcasting: 'None (some subclasses use Intelligence-based spellcasting)',
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
