import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple5e/features/create_character/classes.dart';
import 'package:simple5e/models/spell.dart';
import 'package:simple5e/data/class_repository.dart';
import 'package:simple5e/providers/spell_provider.dart';

class CustomSpellForm extends ConsumerStatefulWidget {
  final Function(Spell) onSpellCreated;

  const CustomSpellForm({super.key, required this.onSpellCreated});

  @override
  ConsumerState<CustomSpellForm> createState() => _CustomSpellFormState();
}

class _CustomSpellFormState extends ConsumerState<CustomSpellForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _castingTimeController = TextEditingController();
  final TextEditingController _rangeController = TextEditingController();
  final TextEditingController _componentsController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _additionalNotesController =
      TextEditingController();
  final List<String> _selectedClasses = [];

  List<String> _availableClasses = [];
  bool _isLoading = false;
  bool _isLoadingClasses = true;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    setState(() {
      _isLoadingClasses = true;
    });
    try {
      final customClasses = await ClassRepository.instance.readAllClasses();
      final customClassesList = customClasses.map((c) => c.name).toList();
      final defaultClasses = classes.map((c) => c.name).toList();
      _availableClasses = [...defaultClasses, ...customClassesList];
      setState(() {
        _isLoadingClasses = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingClasses = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Custom Spell'),
      ),
      body: _isLoading || _isLoadingClasses
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(_nameController, 'Spell Name'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                              child: _buildIntField(_levelController, 'Level')),
                          const SizedBox(width: 16),
                          Expanded(
                              child: _buildTextField(
                                  _schoolController, 'School',
                                  required: false)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                              child: _buildTextField(
                                  _castingTimeController, 'Casting Time',
                                  required: false)),
                          const SizedBox(width: 16),
                          Expanded(
                              child:
                                  _buildTextField(_rangeController, 'Range')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                              child: _buildTextField(
                                  _componentsController, 'Components',
                                  required: false)),
                          const SizedBox(width: 16),
                          Expanded(
                              child: _buildTextField(
                                  _durationController, 'Duration',
                                  required: false)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(_descriptionController, 'Description',
                          maxLines: 5),
                      const SizedBox(height: 16),
                      _buildTextField(
                          _additionalNotesController, 'Additional Notes',
                          maxLines: 3, required: false),
                      const SizedBox(height: 24),
                      Text('Classes',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      _buildClassChips(),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _createSpell,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Create Spell'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1, bool required = true}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      maxLines: maxLines,
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildIntField(TextEditingController controller, String label,
      {int maxLines = 1, bool required = true}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      maxLines: maxLines,
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return 'Please enter $label';
        }
        if (required && value != null && int.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }

  Widget _buildClassChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _availableClasses.map((String className) {
        return FilterChip(
          label: Text(className),
          selected: _selectedClasses.contains(className),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                _selectedClasses.add(className);
              } else {
                _selectedClasses.remove(className);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Future<void> _createSpell() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final newSpell = Spell(
          name: _nameController.text,
          level: _levelController.text,
          castingTime: _castingTimeController.text,
          range: _rangeController.text,
          components: _componentsController.text,
          duration: _durationController.text,
          description: _descriptionController.text,
          additionalNotes: _additionalNotesController.text.isEmpty
              ? null
              : _additionalNotesController.text,
          classes: _selectedClasses,
          isUserDefined: true,
        );

        await ref.read(spellsProvider.notifier).addSpell(newSpell);

        if (mounted) {
          widget.onSpellCreated(newSpell);
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating spell: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _levelController.dispose();
    _schoolController.dispose();
    _castingTimeController.dispose();
    _rangeController.dispose();
    _componentsController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }
}
