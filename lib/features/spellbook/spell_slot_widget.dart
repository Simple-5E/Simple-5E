// lib/features/spellbook/spell_slot_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:titan/data/spell_slot_repository.dart';
import 'package:titan/models/spell_slot.dart';
import 'package:titan/providers/providers.dart';
import 'package:titan/features/spellbook/spell_slot_modal.dart';

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
            onUpdate: (updatedSlot) async {
              await SpellSlotRepository.instance.updateSpellSlot(updatedSlot);
              ref.invalidate(characterSpellSlotsProvider(characterId));
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
