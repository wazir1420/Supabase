import 'dart:io';

import 'package:chatsupa/models/auth_service.dart';
import 'package:chatsupa/models/note_database.dart';
import 'package:chatsupa/models/notes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthService();
  void logOut() async {
    await authService.signOut();
  }

  final noteDatabase = NoteDatabase();
  final noteController = TextEditingController();
  void addNewNote() async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('New Note'),
              content: TextField(
                controller: noteController,
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      noteController.clear();
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () {
                      final newNote = Note(content: noteController.text);
                      noteDatabase.createNote(newNote);
                      noteController.clear();
                      Navigator.pop(context);
                    },
                    child: Text('Save'))
              ],
            ));
  }

  void updateNote(Note note) async {
    noteController.text = note.content;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Update Note'),
              content: TextField(
                controller: noteController,
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      noteController.clear();
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () {
                      noteDatabase.updateNote(note, noteController.text);
                      noteController.clear();
                      Navigator.pop(context);
                    },
                    child: Text('Save'))
              ],
            ));
  }

  void deleteNote(Note note) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Delete Note'),
              actions: [
                TextButton(
                    onPressed: () {
                      noteController.clear();
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () {
                      noteDatabase.deleteNote(note);
                      noteController.clear();
                      Navigator.pop(context);
                    },
                    child: Text('Delete'))
              ],
            ));
  }

  File? imageFile;
  Future pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }

  Future uploadImage() async {
    if (imageFile == null) return;
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = 'uploads/$fileName';
    await Supabase.instance.client.storage
        .from('images')
        .upload(path, imageFile!)
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image Upload Successfully!'))));
  }

  @override
  Widget build(BuildContext context) {
    // final currentEmail = authService.getCurrentUserEmail();
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                logOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNewNote();
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
          stream: noteDatabase.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final notes = snapshot.data!;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note.content),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              updateNote(note);
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              deleteNote(note);
                            },
                            icon: Icon(Icons.delete))
                      ],
                    ),
                  ),
                );
              },
            );
          }),
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            CupertinoButton(
              onPressed: () {
                pickImage();
              },
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    imageFile != null ? FileImage(imageFile!) : null,
                child: imageFile == null
                    ? Icon(
                        Icons.person,
                        size: 60,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Wazir Tatheer Abbas',
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 30,
            ),
            CupertinoButton(
              onPressed: () {
                uploadImage();
              },
              child: Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
