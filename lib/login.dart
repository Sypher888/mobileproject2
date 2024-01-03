import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fromfirebase/home_page.dart';
import 'package:logger/logger.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

final TextEditingController emailData = TextEditingController();
final TextEditingController passwordData = TextEditingController();
final logger = Logger();
bool _isPasswordVisible = false;

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 20),
          child: SizedBox(
            width: 400,
            child: ListView(
              padding: const EdgeInsets.only(top: 20),
              children: [
                Image.network(
                  'https://cdn-icons-png.flaticon.com/128/6681/6681204.png',
                  color: Colors.blue,
                  width: 100,
                  height: 100,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 30, top: 20),
                  child: Text(
                    'Login',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        letterSpacing: 1.5),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 30, top: 5),
                  child: Text(
                    'Login to continue using the app',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 30, top: 5),
                  child: Text(
                    'Email : ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        letterSpacing: 1.5),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: TextFormField(
                    controller: emailData,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      prefixIconColor: Colors.blue,
                      hintText: 'Enter your email..',
                      hintStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                      fillColor: const Color.fromARGB(255, 235, 235, 235),
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 30, top: 5),
                  child: Text(
                    'Password : ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        letterSpacing: 1.5),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: TextFormField(
                    obscureText: !_isPasswordVisible,
                    controller: passwordData,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        child: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.blue,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      prefixIconColor: Colors.blue,
                      hintText: 'Enter your password..',
                      hintStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                      fillColor: const Color.fromARGB(255, 235, 235, 235),
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                InkWell(
                  onTap: () async {
                    if (emailData.text.isNotEmpty) {
                      try {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: emailData.text);
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          btnOkOnPress: () {},
                          title: 'Link for password reset sent to your inbox',
                        ).show();
                        emailData.clear();
                      } catch (e) {
                        print('Error sending password reset email: $e');
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          btnOkOnPress: () {
                            Navigator.of(context).pop();
                          },
                          title: 'Error sending password reset email',
                        ).show();
                      }
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        btnOkOnPress: () {},
                        title: 'Please insert email and press again',
                      ).show();
                    }
                  },
                  child: const Text(
                    'forget password ? ',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: emailData.text,
                                  password: passwordData.text);

                          AwesomeDialog(
                                  title: 'Login successful',
                                  context: context,
                                  dialogType: DialogType.success)
                              .show();
                          await Future.delayed(const Duration(seconds: 2));
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            logger.i('No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            logger.i('Wrong password provided for that user.');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 70,
                      height: 3,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Text(
                      'Or Login With',
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Container(
                      height: 3,
                      width: 70,
                      color: Colors.red,
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.facebook,
                        color: Colors.blue,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Image.network(
                        'https://cdn-icons-png.flaticon.com/128/281/281764.png',
                        width: 22,
                        height: 22,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.apple,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account ?'),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GoogleSignInAccount {}
