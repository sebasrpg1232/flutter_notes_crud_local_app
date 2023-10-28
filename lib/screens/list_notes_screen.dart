import 'package:flutter/material.dart';
import 'package:notes_crud_local_app/providers/actual_option_provider.dart';
import 'package:provider/provider.dart';

import '../providers/notes_provider.dart';

class ListNotesScreen extends StatelessWidget {
  const ListNotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ListNotes();
  }
}

class _ListNotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);

    final notes = notesProvider.notes;

    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (_, index) => ListTile(
        leading: const Icon(Icons.note),
        title: Text(notes[index].title),
        subtitle: Text(notes[index].id.toString()),
        trailing: PopupMenuButton(
          // icon: Icon(Icons.fire_extinguisher),
          onSelected: (int i){
              notesProvider.assignDataWithNote(notes[index]);
              Provider.of<ActualOptionProvider>(context, listen: false).selectedOption = 1;
          },
          itemBuilder: (context) => [
            PopupMenuItem(value:0, child: Text('Actualizar')
            ),
            PopupMenuItem(value:1, child: Text('Eliminar'))
          ],
        ),
      ),
    );
  }
}
