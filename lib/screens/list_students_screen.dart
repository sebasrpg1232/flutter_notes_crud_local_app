import 'package:flutter/material.dart';
import 'package:notes_crud_local_app/providers/actual_option_provider.dart';
import 'package:provider/provider.dart';

import '../providers/students_provider.dart';

class ListStudentsScreen extends StatelessWidget {
  const ListStudentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("hola");
    return _ListStudents();
  }
}

class _ListStudents extends StatelessWidget {
  void displayDialog(
      BuildContext context, StudentsProvider studentsProvider, int id) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            title: const Text('Alerta!'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(10)),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('¿Quiere eliminar definitivamente el registro?'),
                SizedBox(height: 10),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () {
                    studentsProvider.deleteStudentById(id);
                    Navigator.pop(context);
                  },
                  child: const Text('Ok')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    StudentsProvider studentsProvider = Provider.of<StudentsProvider>(context);
    print(studentsProvider.students);
    print("hola");
    final students = studentsProvider.students;

    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (_, index) => ListTile(
        title: Text("Nombre   "+students[index].name),
        subtitle: Text("Id     "+students[index].id.toString()+"\nEdad     "+students[index].age.toString()),

        trailing: PopupMenuButton(
          // icon: Icon(Icons.fire_extinguisher),
          onSelected: (int i) {
            if (i == 0) {
              studentsProvider.createOrUpdate = "update";
              studentsProvider.assignDataWithStudent(students[index]);
              Provider.of<ActualOptionProvider>(context, listen: false)
                  .selectedOption = 3;
              return;
            }

            displayDialog(context, studentsProvider, students[index].id!);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 0, child: Text('Actualizar')),
            const PopupMenuItem(value: 1, child: Text('Eliminar'))
          ],
        ),
      ),
    );
  }
}
