import 'package:flutter/material.dart';

import '../models/student_model.dart';
import 'db_provider.dart';

class StudentsProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String createOrUpdate = 'create';
  int ids = 0;
  String name = '';
  int age = 0;

  bool _isLoading = false;
  List<Student> students = [];

  bool get isLoading => _isLoading;

  set isLoading(bool opc) {
    _isLoading = opc;
  }

  bool isValidForm() {
    print(formKey.currentState?.validate());

    return formKey.currentState?.validate() ?? false;
  }

  addStudent() async {
    final Student student = Student(id: ids, name: name, age: age);

    /*revisar este id*/
    final id = await DBProvider.db.newStudent(student);

    student.id = id;

    students.add(student);

    notifyListeners();
  }

  loadStudents() async {
    final List<Student> students = await DBProvider.db.getAllStudents();
    //operador Spreed
    this.students = [...students];
    notifyListeners();
  }

  updateStudent() async {
    final student = Student(id: ids, name: name, age: age);
    final res = await DBProvider.db.updateStudent(student);
    print("Id actualizado: $res");
    loadStudents();
  }

  deleteStudentById(int id) async {
    final res = await DBProvider.db.deleteStudent(id);
    loadStudents();
  }

  assignDataWithStudent(Student student) {
    ids = student.id;
    name = student.name;
    age = student.age;
  }

  resetStudentData() {
    ids = 0;
    name = '';
    age = 0;
    createOrUpdate = 'create';
  }
}
