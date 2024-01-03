import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fromfirebase/home_page.dart';
import 'package:fromfirebase/note_details.dart';

class BuildNoteItem extends StatefulWidget {
  const BuildNoteItem(this.note, {super.key});
  final QueryDocumentSnapshot note;

  @override
  State<BuildNoteItem> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<BuildNoteItem> {
  deleteNote() async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      animType: AnimType.topSlide,
      title: 'Delete Note',
      desc: 'Are you sure you want to delete this note?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        // Get a reference to the 'trash' collection
        CollectionReference trashCollection =
            FirebaseFirestore.instance.collection('trash');

        // Get the note data
        Map<String, dynamic> noteData =
            widget.note.data() as Map<String, dynamic>;

        // Add the note to the 'trash' collection
        await trashCollection.add(noteData);

        // Delete the note from the 'notes' collection
        await FirebaseFirestore.instance
            .collection('notes')
            .doc(widget.note.id)
            .delete();

        // Navigate to the home page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      },
    )..show();
  }

  showdetails() {}

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NoteDetailsScreen(widget.note)));
      },
      onLongPress: deleteNote,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder, size: 64, color: Colors.blue),
            const SizedBox(height: 8),
            Text(widget.note['name'], style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
