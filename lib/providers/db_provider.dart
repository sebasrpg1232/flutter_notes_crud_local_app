import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

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
}
