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
  late bool _authSuccessful;

  @override
  void initState() {
    _authCredential = widget.authCredential;
    _authSuccessful = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _authSuccessful
          ? FutureBuilder(
              future: FirebaseService.deleteAccount(FirebaseAuth.instance.currentUser!.uid)
                  .then((value) {
                print("Account deleted");
                Future(() => Navigator.of(context).popUntil(ModalRoute.withName("/")));
              }),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  Future(() => Navigator.of(context).pop());
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Authenticated",
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
                            "Deleting account",
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
              future: FirebaseService.reauthenticateWithCredential(_authCredential),
              // future: Future.delayed(const Duration(seconds: 4), () => false),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  Future(() => Navigator.of(context).pop());
                }
                if (snapshot.hasData) {
                  if (snapshot.data!) {
                    Future(() {
                      setState(() {
                        _authSuccessful = true;
                      });
                    });
                  } else {
                    Future(() {
                      Navigator.of(context).pop();
                      _showDialog("Authentication failed", "Password is incorrect");
                    });
                  }
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Authenticating",
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
