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

  @override
  Widget build(BuildContext context) 
 
  {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Login'),
      ),
      body: Form(
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
              SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: 
                  () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final result = login
                      ? await AuthServices.signinUser(email, password, context)
                       : (await signUp(userEmail: email, password: password, context: context)) != null
                        ? Navigator.push(context, MaterialPageRoute(builder: (ctx) => const EmailVerificationScreen()))
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
                  login ? "Don't have an account? Signup" : "Already have an account? Login",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<User?> signUp(
      {required String userEmail,
        required String password,
        required BuildContext context}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: userEmail, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The password provided is too weak.')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The account already exists for that email.')));
      }
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }