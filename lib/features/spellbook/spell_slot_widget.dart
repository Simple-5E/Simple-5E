// lib/features/spellbook/spell_slot_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/models/spell_slot.dart';
import 'package:simple5e/providers/providers.dart';
import 'package:simple5e/features/spellbook/spell_slot_modal.dart';

class SpellSlotWidget extends ConsumerWidget {
  final int characterId;
  final int level;
  final SpellSlot spellSlot;

  const SpellSlotWidget({
    super.key,
    required this.characterId,
    required this.level,
    required this.spellSlot,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => SpellSlotModal(
            spellSlot: spellSlot,
            onUpdate: (updatedSlot) {
              final updateSlot = ref.read(updateSpellSlotProvider(characterId));
              updateSlot(updatedSlot);
            },
          ),
        );
      },
      child: Text(
        'Level $level - ${spellSlot.total - spellSlot.used} / ${spellSlot.total} slots',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
