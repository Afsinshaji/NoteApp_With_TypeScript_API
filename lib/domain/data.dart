import 'note_model/note_model.dart';

abstract class ApiCalls {
  Future<NoteModel?> createNote(NoteModel note);
  Future<NoteModel?> updateNote(NoteModel note);
  Future<void> deleteNote(String id);
  Future<List<NoteModel>?> getAllNote();
}
