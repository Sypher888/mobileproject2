import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fromfirebase/login.dart';
import 'package:fromfirebase/trash.dart';

class Drawerr extends StatefulWidget {
  const Drawerr({super.key});

  @override
  State<Drawerr> createState() => _DrawerrState();
}

class _DrawerrState extends State<Drawerr> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        margin: const EdgeInsets.only(bottom: 20),
        width: 250,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const Trash()));
                  },
                  child: const Text('Trash',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          letterSpacing: 1.5))),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: TextButton(
                  onPressed: () {
                    AwesomeDialog(
                        dialogType: DialogType.warning,
                        title: 'Are you sure ',
                        context: context,
                        btnCancelOnPress: () {
                          Navigator.of(context).pop();
                        },
                        btnOkOnPress: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const Login()));
                        }).show();
                  },
                  child: const Text('Sign Out',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          letterSpacing: 1.5))),
            ),
          ],
        ),
      ),
    );
  }
}
