import 'package:chatsupa/models/notes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NoteDatabase {
  final database = Supabase.instance.client.from('notes');

  Future createNote(Note newNote) async {
    await database.insert(newNote.toMap());
  }

  final stream = Supabase.instance.client.from('notes').stream(primaryKey: [
    'id'
  ]).map((data) => data.map((noteMap) => Note.fromMap(noteMap)).toList());

  Future updateNote(Note oldNote, String newContent) async {
    await database.update({'content': newContent}).eq('id', oldNote.id!);
  }

  Future deleteNote(Note note) async {
    await database.delete().eq('id', note.id!);
  }
}
