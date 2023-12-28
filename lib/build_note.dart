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
      btnOkOnPress: () {
        // User clicked on "Yes," so delete the note
        FirebaseFirestore.instance
            .collection('notes')
            .doc(widget.note.id)
            .delete()
            .then((_) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: ((context) => HomePage()))); // Pop the dialog
        }).catchError((error) {
          print('Error deleting note: $error');
          // Handle the error, if needed
        });
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
