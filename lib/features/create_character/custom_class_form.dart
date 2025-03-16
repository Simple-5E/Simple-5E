import 'package:flutter/material.dart';
import 'package:simple5e/models/character_class.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/providers/custom_class_provider.dart';

class CustomClassForm extends ConsumerWidget {
  const CustomClassForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final hitDieController = TextEditingController(text: 'd8');
    final spellcastingController = TextEditingController(text: 'None');
    final proficienciesController = TextEditingController();

    Widget buildSection(
        {required String title, required List<Widget> children}) {
      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...children,
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Custom Class'),
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            buildSection(
              title: 'Basic Information',
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Class Name',
                    hintText: 'Enter your custom class name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a class name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText:
                        'Describe your class\'s characteristics and abilities',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
              ],
            ),
            buildSection(
              title: 'Class Features',
              children: [
                TextFormField(
                  controller: hitDieController,
                  decoration: const InputDecoration(labelText: 'Hit Die'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: spellcastingController,
                  decoration: const InputDecoration(labelText: 'Spellcasting'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: proficienciesController,
                  decoration: const InputDecoration(
                    labelText: 'Proficiencies',
                    hintText: 'Enter proficiencies separated by commas',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              final customClass = CharacterClass(
                name: nameController.text,
                description: descriptionController.text,
                hitDie: hitDieController.text,
                spellcasting: spellcastingController.text,
                proficiencies: proficienciesController.text
                    .split(',')
                    .map((e) => e.trim())
                    .toList(),
              );
              await ref
                  .read(customClassesProvider.notifier)
                  .addCustomClass(customClass);
              if (context.mounted) {
                Navigator.pop(context, customClass);
              }
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Create Class',
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
