import 'package:flutter/material.dart';
import 'package:note_app/infrastructure/note_db.dart';
import 'package:note_app/presentation/add_note/screen_add_note.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await NoteDB.intstance.getAllNote();
    });
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Note App',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddNoteScreen(actionType: ActionType.addNote),
                    ));
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: ValueListenableBuilder(
            valueListenable: NoteDB.intstance.noteListNotifier,
            builder: (context, noteList, child) {
              if (noteList.isEmpty) {
                return const Center(
                  child: Text('Add new notes'),
                );
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: noteList.length,
                itemBuilder: (context, index) {
                  if (noteList[index].id == null) {
                    return const SizedBox();
                  }
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              noteList[index].title ??= 'No title',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  NoteDB.intstance
                                      .deleteNote(noteList[index].id!);
                                },
                                icon: const Icon(Icons.delete))
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddNoteScreen(
                                  actionType: ActionType.editNote,
                                  noteId: noteList[index].id!,
                                ),
                              )),
                          child: Text(
                            noteList[index].content ??= 'No content',
                            maxLines: 6,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            }));
  }
}
