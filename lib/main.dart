import 'package:flutter/material.dart';
import 'package:notes_crud_local_app/providers/db_provider.dart';

/**
 * 1. Instalar sqflite, path_provider, provider (X)
 * 2. Crear el modelo de Notas (Quicktype.io) (X)
 * 3. Crear el provider de la BD
 * 4. Crear archivo de bd
 * 4. Crear metodos para gestionar datos
 * 
 * 
 */

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DBProvider.db.database;

    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(body: Center(child: Text('Hola'))),
    );
  }
}
