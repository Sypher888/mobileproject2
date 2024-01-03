import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fromfirebase/build_note.dart';
import 'package:fromfirebase/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<QueryDocumentSnapshot> datalist = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    fetchDataFromFirebase();

    super.initState();
  }

  displayError() {
    if (nameController.text.isEmpty || descriptionController.text.isEmpty) {
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'please insert data',
        btnOkOnPress: () => Navigator.of(context).pop(),
      ).show();
    } else {
      CollectionReference createNote =
          FirebaseFirestore.instance.collection('notes');
      createNote.add({
        "name": nameController.text,
        "description": descriptionController.text,
      });
      nameController.clear();
      descriptionController.clear();

      Navigator.of(context).pop();
    }
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      QuerySnapshot data =
          await FirebaseFirestore.instance.collection('notes').get();

      // Check if the widget is mounted before calling setState
      if (mounted) {
        datalist.addAll(data.docs);
        setState(() {
          // Set the state only if the widget is still mounted
        });
        print('its workinggggg');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> showCreateNoteDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create a Note'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: displayError,
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        onPressed: showCreateNoteDialog,
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      drawer: const Drawerr(),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: ((context) => const HomePage())));
              },
              icon: const Icon(
                Icons.refresh,
                size: 30,
                color: Colors.purple,
              ),
            ),
          )
        ],
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Note Legacy'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: datalist.length,
        itemBuilder: (context, index) {
          return BuildNoteItem(datalist[index]);
        },
      ),
    );
  }
}
