import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fromfirebase/home_page.dart';
import 'package:fromfirebase/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _LoginState();
}

final TextEditingController usernameData = TextEditingController();
final TextEditingController emailData = TextEditingController();
final TextEditingController passwordData = TextEditingController();

bool _isPasswordVisible = false;

class _LoginState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
          child: SizedBox(
            width: 400,
            child: ListView(
              children: [
                Image.network(
                  'https://cdn-icons-png.flaticon.com/128/6681/6681204.png',
                  color: Colors.orange,
                  width: 100,
                  height: 100,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 30, top: 20),
                  child: Text(
                    'Sign Up ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        letterSpacing: 1.5),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 30, top: 5),
                  child: Text(
                    'Sign Up to continue using the app',
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
                    'UserName : ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      letterSpacing: 1.5,
                    ),
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
                    style: const TextStyle(color: Colors.black),
                    controller: usernameData,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      prefixIconColor: Colors.orange,
                      hintText: 'User..',
                      hintStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                      fillColor: const Color.fromARGB(255, 235, 235, 235),
                      filled: true,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 30, top: 5),
                  child: Text(
                    'Email : ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      letterSpacing: 1.5,
                    ),
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
                    style: const TextStyle(color: Colors.black),
                    controller: emailData,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      prefixIconColor: Colors.orange,
                      hintText: ' Email address..',
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
                  height: 5,
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
                    style: const TextStyle(color: Colors.black),
                    controller: passwordData,
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
                          color: Colors.orange,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      prefixIconColor: Colors.orange,
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
                  height: 25,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (usernameData.text.isNotEmpty &&
                          emailData.text.isNotEmpty &&
                          passwordData.text.isNotEmpty) {
                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: emailData.text,
                            password: passwordData.text,
                          );
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            animType: AnimType.bottomSlide,
                            title: 'Awesome Dialog',
                          ).show();
                          await Future.delayed(const Duration(seconds: 1));
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            print('The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            print('The account already exists for that email.');
                          }
                        } catch (e) {
                          print(e);
                        }
                      } else {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.bottomSlide,
                          title: ' invalid credentials',
                          btnOkText: 'Ok',
                          btnOkOnPress: () {},
                        ).show();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account!'),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Login()));
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.orange,
                              decoration: TextDecoration.underline),
                        ))
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
