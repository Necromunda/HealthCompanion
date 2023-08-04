import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/screens/authenticate_screen.dart';
import 'package:health_companion/services/firebase_service.dart';
import 'package:health_companion/widgets/change_email_dialog.dart';
import 'package:health_companion/widgets/change_password_dialog.dart';
import 'package:health_companion/widgets/change_username_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../util.dart';

enum Account {
  username,
  email,
  password,
}

class ChangeAccountDetails extends StatefulWidget {
  const ChangeAccountDetails({Key? key}) : super(key: key);

  @override
  State<ChangeAccountDetails> createState() => _ChangeAccountDetailsState();
}

class _ChangeAccountDetailsState extends State<ChangeAccountDetails> {
  late final User _currentUser;
  late bool _isAuthenticated;

  @override
  void initState() {
    print("Init");
    _currentUser = FirebaseAuth.instance.currentUser!;
    _isAuthenticated = false;
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

  void onTapHandler(context, Account operation) async {
    if (!_isAuthenticated) {
      _isAuthenticated = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ReAuthenticate(),
        ),
      );
    }
    print(_isAuthenticated);
    if (_isAuthenticated) {
      switch (operation) {
        case Account.username:
          String? username =
              await _dialogBuilder(context, 'Username', operation);
          if (username != null) {
            bool updateSuccessful =
                await FirebaseService.changeUsername(username);
            if (updateSuccessful) {
              Util.showNotification(
                  context: context,
                  title: 'Username updated',
                  message: 'Your new username is $username');
            } else {
              Util.showNotification(
                  context: context,
                  title: 'Update failed',
                  message: 'Username could not be updated. Try again later');
            }
          }
          break;
        case Account.email:
          String? email = await _dialogBuilder(context, 'Email', operation);
          if (email != null) {
            bool updateSuccessful = await FirebaseService.changeEmail(email);
            if (updateSuccessful) {
              Util.showNotification(
                  context: context,
                  title: 'Email updated',
                  message: 'Your new email is $email');
            } else {
              Util.showNotification(
                  context: context,
                  title: 'Update failed',
                  message: 'Email could not be updated. Try again later');
            }
          }
          break;
        case Account.password:
          String? password =
              await _dialogBuilder(context, 'Username', operation);
          if (password != null) {
            bool updateSuccessful =
                await FirebaseService.changePassword(password);
            if (updateSuccessful) {
              Util.showNotification(
                  context: context,
                  title: 'Password updated',
                  message: 'Your password was updated successfully');
            } else {
              Util.showNotification(
                  context: context,
                  title: 'Update failed',
                  message: 'Password could not be updated. Try again later');
            }
          }
          break;
      }
    }
  }

  Future<String?> _dialogBuilder(
      BuildContext context, String title, Account operation) {
    return showDialog<String?>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        var width = MediaQuery.of(context).size.width;

        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          title: Text('Change ${title.toLowerCase()}'),
          content: SizedBox(
            width: width,
            child: operation == Account.username
                ? const ChangeUsernameDialog()
                : operation == Account.email
                    ? const ChangeEmailDialog()
                    : const ChangePasswordDialog(),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        );
      },
    );
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Change username'),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () => onTapHandler(context, Account.username),
                  ),
                  const Divider(
                    height: 0,
                    indent: 10,
                    endIndent: 10,
                    color: Colors.black,
                  ),
                  ListTile(
                    title: const Text('Change email'),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () => onTapHandler(context, Account.email),
                  ),
                  const Divider(
                    height: 0,
                    indent: 10,
                    endIndent: 10,
                    color: Colors.black,
                  ),
                  ListTile(
                    title: const Text('Change password'),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () => onTapHandler(context, Account.password),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
