import 'package:flutter/material.dart';
import 'package:simple5e/models/spell.dart';

class SpellModal extends StatelessWidget {
  final Spell spell;

  const SpellModal({super.key, required this.spell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(spell.name),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              spell.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16.0),
            Text('Level: ${spell.level}'),
            const SizedBox(height: 8.0),
            Text('Classes: ${spell.classes.join(', ')}'),
            const SizedBox(height: 8.0),
            Text('Casting Time: ${spell.castingTime}'),
            const SizedBox(height: 8.0),
            Text('Range: ${spell.range}'),
            const SizedBox(height: 8.0),
            Text('Components: ${spell.components}'),
            const SizedBox(height: 8.0),
            Text('Duration: ${spell.duration}'),
            const SizedBox(height: 16.0),
            Text(
              'Description',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            Text(spell.description),
            if (spell.additionalNotes != null) ...[
              const SizedBox(height: 16.0),
              Text(
                'Additional Notes',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8.0),
              Text(spell.additionalNotes!),
            ],
          ],
        ),
      ),
    );
  }
}
