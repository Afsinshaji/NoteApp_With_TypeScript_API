import 'package:flutter/material.dart';
import 'package:note_app/domain/note_model/note_model.dart';
import 'package:note_app/infrastructure/note_db.dart';

enum ActionType { addNote, editNote }

class AddNoteScreen extends StatelessWidget {
  AddNoteScreen({super.key, required this.actionType, this.noteId = ''});
  final ActionType actionType;
  final TextEditingController titleEditingController = TextEditingController();
  final TextEditingController noteEditingController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final String noteId;
  @override
  Widget build(BuildContext context) {
    if (actionType == ActionType.editNote) {
      if (noteId.isEmpty) {
        Navigator.pop(context);
      }
      final note = NoteDB.intstance.getNoteById(noteId);
      if (note == null) {
        Navigator.pop(context);
      }
      titleEditingController.text = note!.title ??= '';
      noteEditingController.text = note.content ??= '';
    }
    return Scaffold(
        key: scaffoldKey,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: titleEditingController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: noteEditingController,
                maxLines: 10,
                decoration: const InputDecoration(
                  hintText: 'Note',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll(Colors.blue),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)))),
                  onPressed: () {
                    switch (actionType) {
                      case ActionType.addNote:
                        saveNote();
                        break;
                      case ActionType.editNote:
                        saveEditedNote();
                        break;
                    }
                  },
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 15.0),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ))
            ],
          ),
        ));
  }

  Future<void> saveNote() async {
    final title = titleEditingController.text;
    final note = noteEditingController.text;
    final newNote = NoteModel.create(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: note,
    );
    NoteDB.intstance.createNote(newNote);
    Navigator.pop(scaffoldKey.currentContext!);
  }

  Future<void> saveEditedNote() async {
    final title = titleEditingController.text;
    final note = noteEditingController.text;
    final newNote = NoteModel.create(
      id: noteId,
      title: title,
      content: note,
    );
    NoteDB.intstance.updateNote(newNote);
    Navigator.pop(scaffoldKey.currentContext!);
  }
}
