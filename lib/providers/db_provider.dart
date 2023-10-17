import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

import '../models/note_model.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();

    return _database!;
  }

  Future<Database> initDB() async {
    //Obteniendo direccion base donde se guardará la base de datos
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    //Armamos la url donde quedará la base de datos
    final path = join(documentsDirectory.path, 'NotesDB.db');

    //Imprimos ruta
    print(path);

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) => {},
      onCreate: (db, version) async {
        await db.execute('''

        CREATE TABLE notes(
          id INTEGER PRIMARY KEY,
          title TEXT,
          description TEXT
        )

''');
      },
    );
  }

  Future<int> newNoteRaw(Note note) async {
    final int? id = note.id;
    final String title = note.title;
    final String description = note.description;

    final db =
        await database; //Recibimos instancia de base de datos para trabajar con ella

    final int res = await db.rawInsert('''

      INSERT INTO notes (id, title, description) VALUES ($id, "$title", "$description")

''');
    print(res);
    return res;
  }

  Future<int> newNote(Note note) async {
    final db = await database;

    final int res = await db.insert("notes", note.toJson());

    return res;
  }
}
