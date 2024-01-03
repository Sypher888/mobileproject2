import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Trash extends StatefulWidget {
  const Trash({super.key});

  @override
  State<Trash> createState() => _TrashState();
}

class _TrashState extends State<Trash> {
  List<Map<String, dynamic>> trashItems = [];
  List<String> selectedItems = [];

  @override
  void initState() {
    super.initState();
    // Fetch data from the trash collection when the page is opened
    fetchDataFromTrash();
  }

  Future<void> fetchDataFromTrash() async {
    // Replace 'trash' with your actual collection name
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('trash').get();

    // Extract data from the query snapshot
    List<Map<String, dynamic>> data = querySnapshot.docs
        .map((DocumentSnapshot document) =>
            {'name': document['name'], 'description': document['description']})
        .toList();

    // Update the state to trigger a rebuild with the new data
    setState(() {
      trashItems = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trash Permanent Delete'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              // Show a confirmation dialog before deleting
              _showDeleteConfirmationDialog();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: trashItems.length,
        itemBuilder: (context, index) {
          final item = trashItems[index];
          return ListTile(
            leading: Checkbox(
              value: selectedItems.contains(item['name']),
              onChanged: (value) {
                setState(() {
                  if (value != null && value) {
                    selectedItems.add(item['name']);
                  } else {
                    selectedItems.remove(item['name']);
                  }
                });
              },
            ),
            title: Text(item['name'] ?? ''),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Selected Notes'),
          content:
              const Text('Are you sure you want to delete the selected notes?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteSelectedItems(); // Delete the selected notes
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteSelectedItems() async {
    // Implement your logic to delete selected items
    // Iterate through selectedItems and perform the delete operation
    for (String itemName in selectedItems) {
      // Replace 'trash' with your actual collection name
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('trash')
          .where('name', isEqualTo: itemName)
          .get();

      // Assuming there is at most one document with a matching 'name'
      if (querySnapshot.docs.isNotEmpty) {
        // Get the document reference
        DocumentReference documentReference =
            querySnapshot.docs.first.reference;

        // Delete the document
        await documentReference.delete();
      }

      // Example: Call your delete function here with itemName
      // deleteItem(itemName);
    }

    // Clear the selectedItems list
    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: ((context) => const Trash())));
    });
  }
  // Clear the selectedItems list
}
