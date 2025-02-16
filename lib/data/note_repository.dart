import 'package:sqflite/sqflite.dart';
import 'package:simple5e/models/note.dart';
import 'package:simple5e/data/character_repository.dart';

class NoteRepository {
  static NoteRepository instance = NoteRepository._init();
  final CharacterRepository _characterRepository = CharacterRepository.instance;

  NoteRepository._init();

  Future<Database> get database async => await _characterRepository.database;

  Future<void> createNoteTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS character_notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        characterId INTEGER,
        title TEXT,
        content TEXT,
        createdAt INTEGER,
        updatedAt INTEGER,
        FOREIGN KEY (characterId) REFERENCES characters (id)
      )
    ''');
  }

  Future<int> createNote(Note note) async {
    final db = await database;
    return await db.insert('character_notes', _noteToMap(note),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Note?> readNote(int id) async {
    final db = await database;
    final maps = await db.query(
      'character_notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return _mapToNote(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Note>> readNotesForCharacter(int characterId) async {
    final db = await database;
    final result = await db.query(
      'character_notes',
      where: 'characterId = ?',
      whereArgs: [characterId],
      orderBy: 'updatedAt DESC',
    );

    return result.map((map) => _mapToNote(map)).toList();
  }

  Future<void> updateNote(Note note) async {
    final db = await database;
    await db.update(
      'character_notes',
      _noteToMap(note),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete(
      'character_notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteNotesForCharacter(int characterId) async {
    final db = await database;
    await db.delete(
      'character_notes',
      where: 'characterId = ?',
      whereArgs: [characterId],
    );
  }

  Map<String, dynamic> _noteToMap(Note note) {
    return {
      if (note.id != null) 'id': note.id,
      'characterId': note.characterId,
      'title': note.title,
      'content': note.content,
      'createdAt': note.createdAt.millisecondsSinceEpoch,
      'updatedAt': note.updatedAt.millisecondsSinceEpoch,
    };
  }

  Note _mapToNote(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      characterId: map['characterId'] as int,
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }
}
