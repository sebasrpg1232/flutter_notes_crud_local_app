import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

import '../models/note_model.dart';
import '../models/student_model.dart';

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
    final path = join(documentsDirectory.path, 'StudentDB.db');

    //Imprimos ruta
    print(path);

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) => {},
      onCreate: (db, version) async {
        await db.execute(" CREATE TABLE students(id INTEGER PRIMARY KEY, name text, age int )");
        await db.execute("  CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, description TEXT)");

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

  //Obtener un registro por id
  Future<Note?> getNoteById(int id) async {
    final Database db = await database;

    //usando Query para construir la consulta, con where y argumentos posicionales (whereArgs)
    final res = await db.query('notes', where: 'id = ?', whereArgs: [id]);
    print(res);
    //Preguntamos si trae algun dato. Si lo hace
    return res.isNotEmpty ? Note.fromJson(res.first) : null;
  }

  Future<List<Note>> getAllNotes() async {
    final Database? db = await database;
    final res = await db!.query('notes');
    //Transformamos con la funcion map instancias de nuestro modelo. Si no existen registros, devolvemos una lista vacia
    return res.isNotEmpty ? res.map((n) => Note.fromJson(n)).toList() : [];
  }

  Future<int> updateNote(Note note) async {
    final Database db = await database;
    //con updates, se usa el nombre de la tabla, seguido de los valores en formato de Mapa, seguido del where con parametros posicionales y los argumentos finales
    final res = await db
        .update('notes', note.toJson(), where: 'id = ?', whereArgs: [note.id]);
    return res;
  }

  Future<int> deleteNote(int id) async {
    final Database db = await database;
    final int res = await db.delete('notes', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAllNotes() async {
    final Database db = await database;
    final res = await db.rawDelete('''
      DELETE FROM notes    
    ''');
    return res;
  }


  Future<int> newStudentRaw(Student student) async {
    final int id = student.id;
    final String name = student.name;
    final int age = student.age;

    final db =
    await database; //Recibimos instancia de base de datos para trabajar con ella

    final int res = await db.rawInsert('''

      INSERT INTO students (id, title, description) VALUES ($id, "$name", "$age")

''');
    print(res);
    return res;
  }

  Future<int> newStudent(Student student) async {
    final db = await database;

    final int res = await db.insert("students", student.toJson());

    return res;
  }

  //Obtener un registro por id
  Future<Student?> getStudentById(int id) async {
    final Database db = await database;

    //usando Query para construir la consulta, con where y argumentos posicionales (whereArgs)
    final res = await db.query('students', where: 'id = ?', whereArgs: [id]);
    print(res);
    //Preguntamos si trae algun dato. Si lo hace
    return res.isNotEmpty ? Student.fromJson(res.first) : null;
  }

  Future<List<Student>> getAllStudents() async {
    final Database? db = await database;
    final res = await db!.query('students');
    print(res);
    print("adios");
    //Transformamos con la funcion map instancias de nuestro modelo. Si no existen registros, devolvemos una lista vacia
    return res.isNotEmpty ? res.map((n) => Student.fromJson(n)).toList() : [];
  }

  Future<int> updateStudent(Student student) async {
    final Database db = await database;
    //con updates, se usa el nombre de la tabla, seguido de los valores en formato de Mapa, seguido del where con parametros posicionales y los argumentos finales
    final res = await db
        .update('students', student.toJson(), where: 'id = ?', whereArgs: [student.id]);
    return res;
  }

  Future<int> deleteStudent(int id) async {
    final Database db = await database;
    final int res = await db.delete('students', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAllStudents() async {
    final Database db = await database;
    final res = await db.rawDelete('''
      DELETE FROM students    
    ''');
    return res;
  }
}
