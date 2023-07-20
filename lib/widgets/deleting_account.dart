import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/loading_screen.dart';
import '../services/firebase_service.dart';

class DeletingAccount extends StatefulWidget {
  final AuthCredential authCredential;

  const DeletingAccount({Key? key, required this.authCredential}) : super(key: key);

  @override
  State<DeletingAccount> createState() => _DeletingAccountState();
}

class _DeletingAccountState extends State<DeletingAccount> {
  late final _authCredential;

  @override
  void initState() {
    _authCredential = widget.authCredential;
    super.initState();
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
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Dismiss"),
          ),
        ],
      ),
    );
  }

  Widget _showProgress({required bool authCheck, required bool deleteCheck}) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: CircularProgressIndicator(),
            ),
            if (authCheck)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Authenticated"),
                  if (authCheck)
                    const Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                ],
              )
            else
              const Text("Authenticating"),
            if (deleteCheck)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Account deleted"),
                  if (authCheck)
                    const Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                ],
              )
            else
              const Text("Deleting account"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseService.reauthenticateWithCredential(_authCredential),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          Future(() => Navigator.of(context).pop());
        }
        if (snapshot.hasData) {
          if (snapshot.data!) {
            Future(() => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FutureBuilder(
                      // future: Future.delayed(const Duration(seconds: 2), () => true),
                      future: FirebaseService.deleteAccount(FirebaseAuth.instance.currentUser!.uid),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          Future(() => Navigator.of(context).pop());
                        }
                        if (snapshot.hasData) {
                          print("Account deleted");
                          Future.delayed(const Duration(seconds: 2), () {
                            _showProgress(authCheck: true, deleteCheck: false);
                            Navigator.of(context).pop();
                          });
                          // Future(() => Navigator.of(context).pop());
                        }
                        return _showProgress(authCheck: true, deleteCheck: false);
                      },
                    ),
                  ),
                ));
          } else {
            Future(() {
              Navigator.of(context).pop();
              _showDialog("Authentication failed", "Password is incorrect");
            });
          }
        }
        return _showProgress(authCheck: false, deleteCheck: false);
      },
    );
  }
}
