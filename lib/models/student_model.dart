// To parse this JSON data, do
//
//     final note = noteFromJson(jsonString);

import 'dart:convert';

Student studentFromJson(String str) => Student.fromJson(json.decode(str));

String studentToJson(Student data) => json.encode(data.toJson());

class Student {
  int id;
  String name;
  int age;

  Student({
    required this.id,
    required this.name,
    required this.age,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    id: json["id"],
    name: json["name"],
    age: json["age"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "age": age
  };
}
