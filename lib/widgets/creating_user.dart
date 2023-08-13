import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:health_companion/services/firebase_service.dart';

class CreatingUser extends StatefulWidget {
  final String username, email, password;
  final DateTime dateOfBirth;
  final double height, weight;

  const CreatingUser({
    Key? key,
    required this.email,
    required this.password,
    required this.username,
    required this.dateOfBirth,
    required this.height,
    required this.weight,
  }) : super(key: key);

  @override
  State<CreatingUser> createState() => _CreatingUserState();
}

class _CreatingUserState extends State<CreatingUser> {
  late final String _username, _email, _password;

  late final DateTime _dateOfBirth;
  late final double _height, _weight;
  late bool _isRegisterSuccessful;

  @override
  void initState() {
    _username = widget.username;
    _email = widget.email;
    _password = widget.password;
    _dateOfBirth = widget.dateOfBirth;
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
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil(ModalRoute.withName("/"));
            },
            child: Text(AppLocalizations.of(context)!.signIn),
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
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  Future(() => Navigator.of(context).pop());
                  if (snapshot.error is FirebaseAuthException) {
                    FirebaseAuthException firebaseError =
                        snapshot.error as FirebaseAuthException;
                    switch (firebaseError.code) {
                      case "email-already-in-use":
                        Future(
                          () => _showDialog(
                            AppLocalizations.of(context)!.emailAlreadyInUse,
                            AppLocalizations.of(context)!.signInToContinue,
                          ),
                        );
                        break;
                      case "invalid-email":
                        Future(
                          () => _showDialog(
                            AppLocalizations.of(context)!.error,
                            AppLocalizations.of(context)!.invalidEmail,
                          ),
                        );
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
                        children: [
                          Text(
                            AppLocalizations.of(context)!.registering,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            ),
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
                dateOfBirth: _dateOfBirth,
                height: _height,
                weight: _weight,
                email: _email,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  Future(() => Navigator.of(context).pop());
                  _showDialog(
                    AppLocalizations.of(context)!.error,
                    AppLocalizations.of(context)!.errorCreatingAccount,
                  );
                }
                if (snapshot.hasData) {
                  Future(
                    () => Navigator.of(context).popUntil(
                      ModalRoute.withName("/"),
                    ),
                  );
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.registerSuccessful,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const Padding(
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
                        children: [
                          Text(
                            AppLocalizations.of(context)!.creatingAccount,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            ),
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
