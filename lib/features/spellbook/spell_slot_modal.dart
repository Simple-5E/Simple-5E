import 'package:flutter/material.dart';
import 'package:titan/models/spell_slot.dart';

class SpellSlotModal extends StatefulWidget {
  final SpellSlot spellSlot;
  final Function(SpellSlot) onUpdate;

  const SpellSlotModal({
    super.key,
    required this.spellSlot,
    required this.onUpdate,
  });

  @override
  SpellSlotModalState createState() => SpellSlotModalState();
}

class SpellSlotModalState extends State<SpellSlotModal> {
  late int used;
  late int total;

  @override
  void initState() {
    super.initState();
    used = widget.spellSlot.used;
    total = widget.spellSlot.total;
  }

  void _updateSpellSlot() {
    final updatedSlot = SpellSlot(
      id: widget.spellSlot.id,
      characterId: widget.spellSlot.characterId,
      level: widget.spellSlot.level,
      total: total,
      used: used,
    );
    widget.onUpdate(updatedSlot);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Level ${widget.spellSlot.level} Slots'),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text('Used'),
                    Text('$used'),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (used > 0) {
                              setState(() => used--);
                              _updateSpellSlot();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            if (used < total) {
                              setState(() => used++);
                              _updateSpellSlot();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Total'),
                    Text('$total'),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (total > 0) {
                              setState(() {
                                total--;
                                used = used.clamp(0, total);
                              });
                              _updateSpellSlot();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() => total++);
                            _updateSpellSlot();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
