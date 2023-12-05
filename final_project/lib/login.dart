import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'auth_functions.dart';
import 'verification_screen.dart';
import 'dbops.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String fullname = '';
  bool login = false;
  String errorMessage = '';
  bool stayLoggedIn = false;

  @override
  void initState() {
    super.initState();
    final auth = FirebaseAuth.instanceFor(
        app: Firebase.app(), persistence: Persistence.NONE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Login'),
          backgroundColor: Colors.grey[900],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF3366FF),
                Color(0xFF6633FF),
              ],
            ),
          ),
          child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (login && errorMessage.isNotEmpty)
                    Text(
                      errorMessage,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  login
                      ? Container()
                      : TextFormField(
                          style: TextStyle(color: Colors.white),
                          key: ValueKey('fullname'),
                          decoration: InputDecoration(
                            hintText: 'Enter Full Name',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Full Name';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            setState(() {
                              fullname = value!;
                            });
                          },
                        ),

                  // ======== Email ========
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    key: ValueKey('email'),
                    decoration: InputDecoration(
                      hintText: 'Enter Email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please Enter valid Email';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      setState(() {
                        email = value!;
                      });
                    },
                  ),
                  // ======== Password ========
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    key: ValueKey('password'),
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
                    ),
                    onSaved: (value) {
                      setState(() {
                        password = value!;
                      });
                    },
                  ),
                  if (login)
                    CheckboxListTile(
                        title: Text('Stay Signed In? (Web Only)',
                        style: TextStyle(color: Colors.grey[900]),),
                        value: stayLoggedIn,
                        onChanged: (signin) {
                          setState(() {
                            stayLoggedIn = signin!;
                            print('Status = $stayLoggedIn');
                            FirebaseAuth.instance.setPersistence(stayLoggedIn
                                ? Persistence.LOCAL
                                : Persistence.NONE);
                          });
                        }),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 55,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[900]),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final result = login
                              ? await AuthServices.signinUser(
                                  email, password, context)
                              : (await signUp(
                                          userEmail: email,
                                          password: password,
                                          username: fullname,
                                          context: context)) !=
                                      null
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) =>
                                              const EmailVerificationScreen()))
                                  : null;

                          if (login && (result == null || result.isEmpty)) {
                            setState(() {
                              errorMessage = 'Invalid email or password.';
                            });
                          } else {
                            setState(() {
                              errorMessage = '';
                            });
                          }
                        }
                      },
                      child: Text(login ? 'Login' : 'Signup'),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        login = !login;
                        errorMessage = '';
                      });
                    },
                    child: Text(
                      login
                          ? "Don't have an account? Signup"
                          : "Already have an account? Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

Future<User?> signUp({
  required String userEmail,
  required String password,
  required String username, // Add username parameter
  required BuildContext context,
}) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: userEmail, password: password);

    // Update user's profile with the username
    await userCredential.user?.updateProfile(displayName: username);

    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The password provided is too weak.')));
    } else if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('The account already exists for that email.')));
    }
    return null;
  } catch (e) {
    debugPrint(e.toString());
    return null;
  }
}
