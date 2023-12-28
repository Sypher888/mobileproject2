import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoteDetailsScreen extends StatefulWidget {
  const NoteDetailsScreen(this.note, {super.key});
  final QueryDocumentSnapshot note;

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${widget.note['name']}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Description: ${widget.note['description']}',
                style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
