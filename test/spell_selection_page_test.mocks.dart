// Mocks generated by Mockito 5.4.5 from annotations
// in simple5e/test/spell_selection_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:simple5e/data/spell_repository.dart' as _i3;
import 'package:simple5e/models/spell.dart' as _i5;
import 'package:sqflite/sqflite.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDatabase_0 extends _i1.SmartFake implements _i2.Database {
  _FakeDatabase_0(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

/// A class which mocks [SpellRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockSpellRepository extends _i1.Mock implements _i3.SpellRepository {
  MockSpellRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Database> get database => (super.noSuchMethod(
        Invocation.getter(#database),
        returnValue: _i4.Future<_i2.Database>.value(
          _FakeDatabase_0(this, Invocation.getter(#database)),
        ),
      ) as _i4.Future<_i2.Database>);

  @override
  _i4.Future<void> createSpellTables(_i2.Database? db) => (super.noSuchMethod(
        Invocation.method(#createSpellTables, [db]),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> createSpell(_i5.Spell? spell) => (super.noSuchMethod(
        Invocation.method(#createSpell, [spell]),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<_i5.Spell?> readSpell(String? name) => (super.noSuchMethod(
        Invocation.method(#readSpell, [name]),
        returnValue: _i4.Future<_i5.Spell?>.value(),
      ) as _i4.Future<_i5.Spell?>);

  @override
  _i4.Future<void> clearDB() => (super.noSuchMethod(
        Invocation.method(#clearDB, []),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<List<_i5.Spell>> readAllSpells() => (super.noSuchMethod(
        Invocation.method(#readAllSpells, []),
        returnValue: _i4.Future<List<_i5.Spell>>.value(<_i5.Spell>[]),
      ) as _i4.Future<List<_i5.Spell>>);

  @override
  _i4.Future<List<_i5.Spell>> readAllUserDefinedSpells() => (super.noSuchMethod(
        Invocation.method(#readAllUserDefinedSpells, []),
        returnValue: _i4.Future<List<_i5.Spell>>.value(<_i5.Spell>[]),
      ) as _i4.Future<List<_i5.Spell>>);

  @override
  _i4.Future<void> updateSpell(_i5.Spell? spell) => (super.noSuchMethod(
        Invocation.method(#updateSpell, [spell]),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> deleteSpell(String? name) => (super.noSuchMethod(
        Invocation.method(#deleteSpell, [name]),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> addSpellToCharacter(int? characterId, String? spellName) =>
      (super.noSuchMethod(
        Invocation.method(#addSpellToCharacter, [characterId, spellName]),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> removeSpellFromCharacter(
    int? characterId,
    String? spellName,
  ) =>
      (super.noSuchMethod(
        Invocation.method(#removeSpellFromCharacter, [
          characterId,
          spellName,
        ]),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> clearSpellsForCharacter(int? characterId) =>
      (super.noSuchMethod(
        Invocation.method(#clearSpellsForCharacter, [characterId]),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<List<_i5.Spell>> readSpellsForCharacter(int? characterId) =>
      (super.noSuchMethod(
        Invocation.method(#readSpellsForCharacter, [characterId]),
        returnValue: _i4.Future<List<_i5.Spell>>.value(<_i5.Spell>[]),
      ) as _i4.Future<List<_i5.Spell>>);
}
