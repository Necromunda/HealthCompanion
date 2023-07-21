import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/screens/loading_screen.dart';
import 'package:health_companion/services/firebase_service.dart';
import 'package:health_companion/widgets/deleting_account.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  late final TextEditingController _passwordController;
  late bool _deleteConfirm, _isPasswordValid;
  late final RegExp _passwordRegExp;
  late final User _currentUser;

  @override
  void initState() {
    _currentUser = FirebaseAuth.instance.currentUser!;
    _deleteConfirm = false;
    _isPasswordValid = false;
    _passwordController = TextEditingController();
    _passwordRegExp =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_\-+=]).{8,63}$');
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
    _passwordController.dispose();
    super.dispose();
  }

  void _cancelButtonHandler() {
    Navigator.of(context).pop();
  }

  void _proceedButtonHandler() {
    setState(() {
      _deleteConfirm = true;
    });
  }

  void _deleteAccountButtonHandler() async {
    try {
      String password = _passwordController.text;
      final AuthCredential credential =
          EmailAuthProvider.credential(email: _currentUser.email!, password: password);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DeletingAccount(authCredential: credential)
        ),
      );
    } catch (e, stackTrace) {
      print("Error deleting user: $e, $stackTrace");
    }
  }

  Color get _passwordColor => _passwordController.text.isEmpty
      ? Colors.grey
      : _isPasswordValid
          ? Colors.green
          : Colors.red;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: _deleteConfirm
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    onChanged: (value) => setState(() {
                      if (_passwordRegExp.hasMatch(value)) {
                        _isPasswordValid = true;
                      } else {
                        _isPasswordValid = false;
                      }
                    }),
                    decoration: InputDecoration(
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _passwordController.text.isEmpty ? Colors.grey : Colors.red,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _passwordColor,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _passwordColor,
                          width: 2.0,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.password,
                        color: _passwordColor,
                      ),
                      // label: Text("Password"),
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          width: 2.0,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isPasswordValid ? _deleteAccountButtonHandler : null,
                      style: FilledButton.styleFrom(
                        // backgroundColor: Colors.deepPurple.shade400,
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0),
                        ),
                      ),
                      child: const Text("Delete my account"),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Are you sure you want to delete your account?\nThis action is permanent.",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: _cancelButtonHandler,
                          style: FilledButton.styleFrom(
                            // backgroundColor: Colors.deepPurple.shade400,
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.0),
                            ),
                          ),
                          child: const Text("No, take me back"),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: FilledButton(
                          onPressed: _proceedButtonHandler,
                          style: FilledButton.styleFrom(
                            // backgroundColor: Colors.deepPurple.shade400,
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.0),
                            ),
                          ),
                          child: const Text("Proceed"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
      ),
    );
  }
}
