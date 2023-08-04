import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/services/firebase_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../util.dart';

class ReAuthenticate extends StatefulWidget {
  const ReAuthenticate({Key? key}) : super(key: key);

  @override
  State<ReAuthenticate> createState() => _ReAuthenticateState();
}

class _ReAuthenticateState extends State<ReAuthenticate> {
  late final TextEditingController _passwordController;
  late bool _isPasswordValid, _obscureText, _authenticating;
  late final RegExp _passwordRegExp;
  late final User _currentUser;
  late AuthCredential _credential;

  @override
  void initState() {
    _currentUser = FirebaseAuth.instance.currentUser!;
    _isPasswordValid = false;
    _authenticating = false;
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
          hintText: "Password",
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

  void _onPressedHandler() async {
    AuthCredential credential = EmailAuthProvider.credential(
        email: _currentUser.email!, password: _passwordController.text);
    _credential = credential;
    setState(() {
      _authenticating = true;
    });
  }

  Color get authButtonColor => Util.isDark(context)
      ? Theme.of(context).colorScheme.onTertiary
      : Theme.of(context).colorScheme.tertiary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: _authenticating
            ? Center(
                child: FutureBuilder(
                  future:
                  // Future.delayed(Duration(seconds: 2), () => true),
                  FirebaseService.reauthenticateWithCredential(_credential),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      Future(() {
                        Navigator.of(context).pop(false);
                        _showDialog(
                            "Authentication failed", "Something went wrong");
                      });
                    }
                    if (snapshot.hasData) {
                      if (snapshot.data!) {
                        Future(() => Navigator.of(context).pop(true));
                      } else {
                        Future(() {
                          Navigator.of(context).pop(false);
                          _showDialog(
                              "Authentication failed", "Password is incorrect");
                        });
                      }
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Authenticating',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        )
                      ],
                    );
                  },
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _passwordTextField,
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isPasswordValid ? _onPressedHandler : null,
                      style: FilledButton.styleFrom(
                        // backgroundColor: Colors.redAccent,
                        backgroundColor: authButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0),
                        ),
                      ),
                      child: const Text(
                        'Authenticate',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
