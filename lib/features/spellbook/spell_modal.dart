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
            SizedBox(height: 8.0),
            Text('Classes: ${spell.classes.join(', ')}'),
            SizedBox(height: 8.0),
            Text('Casting Time: ${spell.castingTime}'),
            SizedBox(height: 8.0),
            Text('Range: ${spell.range}'),
            SizedBox(height: 8.0),
            Text('Components: ${spell.components}'),
            SizedBox(height: 8.0),
            Text('Duration: ${spell.duration}'),
            SizedBox(height: 16.0),
            Text(
              'Description',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8.0),
            Text(spell.description),
            if (spell.additionalNotes != null) ...[
              SizedBox(height: 16.0),
              Text(
                'Additional Notes',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 8.0),
              Text(spell.additionalNotes!),
            ],
          ],
        ),
      ),
    );
  }
}
