import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/screens/loading_screen.dart';
import 'package:health_companion/services/firebase_service.dart';
import 'package:health_companion/widgets/deleting_account.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../util.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  late final TextEditingController _passwordController;
  late bool _deleteConfirm, _isPasswordValid, _obscureText;
  late final RegExp _passwordRegExp;
  late final User _currentUser;

  @override
  void initState() {
    _currentUser = FirebaseAuth.instance.currentUser!;
    _deleteConfirm = false;
    // _isPasswordValid = false;
    _isPasswordValid = true;
    _obscureText = true;
    _passwordController = TextEditingController();
    _passwordRegExp = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_\-+=]).{8,63}$');
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
      // String password = _passwordController.text;
      String password = 'Test000!';
      final AuthCredential credential = EmailAuthProvider.credential(
          email: _currentUser.email!, password: password);

      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => DeletingAccount(authCredential: credential)),
      );
    } catch (e, stackTrace) {
      print("Error deleting user: $e, $stackTrace");
    }
  }

  Widget get _passwordTextField => TextField(
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        controller: _passwordController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: _obscureText,
        maxLength: 64,
        onChanged: (value) {
          setState(() {
            _isPasswordValid = _passwordRegExp.hasMatch(value);
          });
        },
        style: TextStyle(
          color: Util.isDark(context) ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
          counterText: "",
          hintText: AppLocalizations.of(context)!.hintPassword,
          contentPadding: EdgeInsets.zero,
          filled: true,
          // fillColor: const Color(0XDEDEDEDE),
          fillColor: Theme.of(context).colorScheme.secondaryContainer,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 2.0,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 2.0,
            ),
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.only(right: 15.0),
            // padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: _passwordController.text.isEmpty
                  ? null
                  : _isPasswordValid
                      ? Colors.lightGreen
                      : Colors.redAccent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5.0),
                bottomLeft: Radius.circular(5.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(1),
                  spreadRadius: -1,
                  offset: const Offset(2, 0), // changes position of shadow
                ),
                BoxShadow(
                  // color: const Color(0XDEDEDEDE).withOpacity(1),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  spreadRadius: 0,
                  offset: const Offset(1, 0), // changes position of shadow
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.key,
                size: 30,
              ),
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              // color: Colors.black87,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
      );

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
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: _deleteConfirm
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _passwordTextField,
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed:
                          _isPasswordValid ? _deleteAccountButtonHandler : null,
                      style: FilledButton.styleFrom(
                        // backgroundColor: Colors.deepPurple.shade400,
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0),
                        ),
                      ),
                      child: Text(AppLocalizations.of(context)!.deleteAccount, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.deleteAccountWarning,
                    style: const TextStyle(fontSize: 20),
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
                            backgroundColor: Colors.lightGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.0),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
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
                          child: Text(
                            AppLocalizations.of(context)!.proceed,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
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
