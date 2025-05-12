import 'package:flutter/material.dart';

import 'Note.dart';
import 'note_database.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    home: NotePage(),
    debugShowCheckedModeBanner: false,
  );
}

class NotePage extends StatefulWidget {
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  List<Note> notes = [];

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  void refreshNotes() async {
    final data = await NoteDatabase.instance.readAllNotes();
    setState(() {
      notes = data;
    });
  }

  void addNote() async {
    final title = titleController.text;
    final content = contentController.text;
    if (title.isEmpty || content.isEmpty) return;

    await NoteDatabase.instance.create(
      Note(title: title, content: content),
    );

    titleController.clear();
    contentController.clear();
    refreshNotes();
  }

  void deleteNote(int id) async {
    await NoteDatabase.instance.delete(id);
    refreshNotes();
  }

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text("Notes App")),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: 'Content'),
              ),
              ElevatedButton(onPressed: addNote, child: Text("Add Note")),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.content),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteNote(note.id!),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
