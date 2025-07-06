import 'package:flutter/material.dart';
import 'package:simple5e/models/race.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/providers/custom_race_provider.dart';

final abilitiesProvider = StateProvider<List<RaceAbility>>((ref) => []);

class CustomRaceForm extends ConsumerWidget {
  const CustomRaceForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final speedController = TextEditingController(text: '30 feet');
    final sizeController = TextEditingController(text: 'Medium');
    final languagesController = TextEditingController(text: 'Common');
    final ageController = TextEditingController(text: '20');
    final alignmentController = TextEditingController(text: 'Neutral');
    final abilityNameController = TextEditingController();
    final abilityDescriptionController = TextEditingController();
    final abilities = ref.watch(abilitiesProvider);
    void addAbility() {
      if (abilityNameController.text.isNotEmpty &&
          abilityDescriptionController.text.isNotEmpty) {
        ref.read(abilitiesProvider.notifier).state = [
          ...abilities,
          RaceAbility(
            name: abilityNameController.text,
            description: abilityDescriptionController.text,
          ),
        ];
        abilityNameController.clear();
        abilityDescriptionController.clear();
      }
    }

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
        title: const Text('Create Custom Race'),
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
                    labelText: 'Race Name',
                    hintText: 'Enter your custom race name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a race name';
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
                        'Describe your race\'s characteristics and culture',
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
              title: 'Racial Traits',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: speedController,
                        decoration: const InputDecoration(labelText: 'Speed'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: sizeController,
                        decoration: const InputDecoration(labelText: 'Size'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: ageController,
                        decoration: const InputDecoration(labelText: 'Age'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: alignmentController,
                        decoration:
                            const InputDecoration(labelText: 'Alignment'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: languagesController,
                  decoration: const InputDecoration(labelText: 'Languages'),
                ),
              ],
            ),
            buildSection(
              title: 'Special Abilities',
              children: [
                if (abilities.isNotEmpty) ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: abilities.length,
                    itemBuilder: (context, index) {
                      final ability = abilities[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(ability.name),
                          subtitle: Text(ability.description),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              final newAbilities =
                                  List<RaceAbility>.from(abilities);
                              newAbilities.removeAt(index);
                              ref.read(abilitiesProvider.notifier).state =
                                  newAbilities;
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  controller: abilityNameController,
                  decoration: const InputDecoration(
                    labelText: 'Ability Name',
                    hintText: 'Enter ability name',
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: abilityDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Ability Description',
                    hintText: 'Describe the ability',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: addAbility,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Ability'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
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
              color: Colors.black.withAlpha(25),
              blurRadius: 4,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              final customRace = Race(
                name: nameController.text,
                description: descriptionController.text,
                abilityScoreIncrease: '',
                speed: speedController.text,
                size: sizeController.text,
                languages: languagesController.text,
                abilities: abilities,
                age: ageController.text,
                alignment: alignmentController.text,
              );
              await ref
                  .read(customRacesProvider.notifier)
                  .addCustomRace(customRace);
              if (context.mounted) {
                Navigator.pop(context, customRace);
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
            'Create Race',
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
