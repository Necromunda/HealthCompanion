import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangeAccountDetails extends StatefulWidget {
  const ChangeAccountDetails({Key? key}) : super(key: key);

  @override
  State<ChangeAccountDetails> createState() => _ChangeAccountDetailsState();
}

class _ChangeAccountDetailsState extends State<ChangeAccountDetails> {
  late final User _currentUser;

  @override
  void initState() {
    _currentUser = FirebaseAuth.instance.currentUser!;
    // print(DateTime.now().difference(_currentUser.metadata.creationTime!).inDays);
    _checkAccountCreationDate();
    super.initState();
  }

  void _checkAccountCreationDate() {
    int days = DateTime.now().difference(_currentUser.metadata.creationTime!).inDays;
    days = 465;
    if (days >= 365) {
      print("Account  is 1 year old");
    } else if (days >= 165) {
      print("Account  is 6 months old");
    } else if (days >= 28) {
      print("Account  is 1 month old");
    } else if (days >= 7) {
      print("Account  is 7 days old");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Placeholder(),
      ),
    );
  }
}
