import 'package:flutter/material.dart';

import '../models/note_model.dart';
import 'db_provider.dart';

class NotesProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String createOrUpdate = 'create';
  int? id;
  String title = '';
  String description = '';

  bool _isLoading = false;
  List<Note> notes = [];

  bool get isLoading => _isLoading;

  set isLoading(bool opc) {
    _isLoading = opc;
  }

  bool isValidForm() {
    print(formKey.currentState?.validate());

    return formKey.currentState?.validate() ?? false;
  }

  Future<Note> addNote() async {
    final Note note = Note(title: title, description: description);

    final id = await DBProvider.db.newNote(note);

    note.id = id;

    notes.add(note);

    notifyListeners();

    return note;
  }

  loadNotes() async {
    final List<Note> notes = await DBProvider.db.getAllNotes();
    //operador Spreed
    this.notes = [...notes];
    notifyListeners();
  }

  updateNote()async{
    final note = Note(id:id, title: title, description: description);
    final res = await DBProvider.db.updateNote(note);
    print("Id actualizado: $res");
    loadNotes();
  }

  assignDataWithNote(Note note){
    id = note.id;
    title = note.title;
    description = note.description;

  }

  resetNoteData(){
    id = null;
    title = '';
    description = '';
    createOrUpdate = 'create';
  }

}
