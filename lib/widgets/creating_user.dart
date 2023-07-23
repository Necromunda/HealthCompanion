import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/firebase_service.dart';

class CreatingUser extends StatefulWidget {
  final String username, email, password;
  final int age;
  final double height, weight;

  const CreatingUser({
    Key? key,
    required this.email,
    required this.password,
    required this.username,
    required this.age,
    required this.height,
    required this.weight,
  }) : super(key: key);

  @override
  State<CreatingUser> createState() => _CreatingUserState();
}

class _CreatingUserState extends State<CreatingUser> {
  late final String _username, _email, _password;
  late final int _age;
  late final double _height, _weight;
  late bool _isRegisterSuccessful;

  @override
  void initState() {
    _username = widget.username;
    _email = widget.email;
    _password = widget.password;
    _age = widget.age;
    _height = widget.height;
    _weight = widget.weight;
    _isRegisterSuccessful = false;
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _showDialog(String title, String message) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          ButtonBar(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil(ModalRoute.withName("/"));
                },
                child: const Text("Sign in"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Dismiss"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isRegisterSuccessful
          ? FutureBuilder(
              future: FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: _email,
                password: _password,
              ),
              // future: Future.delayed(const Duration(seconds: 4), () => false),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  Future(() => Navigator.of(context).pop());
                  if (snapshot.error is FirebaseAuthException) {
                    FirebaseAuthException firebaseError = snapshot.error as FirebaseAuthException;
                    switch (firebaseError.code) {
                      case "email-already-in-use":
                        Future(() => _showDialog("Email address already in use",
                            "$_email is already in use. Login to continue using HealthCompanion."));
                        break;
                      case "invalid-email":
                        Future(() => _showDialog("Invalid email", "$_email is not valid."));
                        break;
                    }
                  }
                }
                if (snapshot.hasData) {
                  Future(() {
                    setState(() {
                      _isRegisterSuccessful = true;
                    });
                  });
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Registering",
                            style: TextStyle(fontSize: 18),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child:
                                SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
          : FutureBuilder(
              future: FirebaseService.createUserOnSignup(
                user: FirebaseAuth.instance.currentUser!,
                username: _username,
                age: _age,
                height: _height,
                weight: _weight,
                email: _email,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  Future(() => Navigator.of(context).pop());
                  _showDialog("Error", "User could not be created.\nContact support.");
                }
                if (snapshot.hasData) {
                  Future(() => Navigator.of(context).popUntil(ModalRoute.withName("/")));
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Register successful",
                            style: TextStyle(fontSize: 18),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Creating account",
                            style: TextStyle(fontSize: 18),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child:
                                SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
