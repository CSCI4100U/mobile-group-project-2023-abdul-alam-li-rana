import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Functionality/auth_functions.dart';
import 'verification_screen.dart';
import '../Functionality/dbops.dart';
import '../main.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String fullname = '';
  bool login = false;
  String errorMessage = '';
  bool stayLoggedIn = false;

  late AnimationController _controller;
  late Animation<Color?> _backgroundColorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    );

    _backgroundColorAnimation = ColorTween(
      begin: Colors.lightBlue, // Starting color
      end: Colors.purple, // Ending color
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Login'),
        backgroundColor: Colors.grey[900],
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.lightBlue,
                  _backgroundColorAnimation.value ?? Colors.purple,
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
                        title: Text(
                          'Stay Signed In? (Web Only)',
                          style: TextStyle(color: Colors.grey[900]),
                        ),
                        value: stayLoggedIn,
                        onChanged: (signin) {
                          setState(() {
                            stayLoggedIn = signin!;
                            print('Status = $stayLoggedIn');
                            FirebaseAuth.instance.setPersistence(stayLoggedIn
                                ? Persistence.LOCAL
                                : Persistence.NONE);
                          });
                        },
                      ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 55,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[900],
                        ),
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

                            if (login &&
                                (result == null || result.isEmpty)) {
                              setState(() {
                                errorMessage =
                                'Invalid email or password.';
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
          );
        },
      ),
    );
  }
}

Future<User?> signUp({
  required String userEmail,
  required String password,
  required String username,
  required BuildContext context,
}) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: userEmail, password: password);

    await userCredential.user?.updateProfile(displayName: username);

    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The password provided is too weak.')),
      );
    } else if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The account already exists for that email.'),
        ),
      );
    }
    return null;
  } catch (e) {
    debugPrint(e.toString());
    return null;
  }
}
