import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/models/appuser_model.dart';
import 'package:health_companion/screens/loading_screen.dart';
import 'package:health_companion/services/firebase_service.dart';
import 'package:health_companion/widgets/creating_user.dart';
import 'package:health_companion/widgets/signup_info_card.dart';

import '../screens/signin_screen.dart';
import 'custom_button.dart';

class SignUpPassword extends StatefulWidget {
  final int pageIndex;
  final Function inputCallback,
      switchPageCallback,
      getUsernameCallback,
      // getAgeCallback,
      getDateOfBirthCallback,
      getHeightCallback,
      getWeightCallback,
      getEmailCallback,
      getPasswordCallback;

  const SignUpPassword({
    Key? key,
    required this.pageIndex,
    required this.inputCallback,
    required this.switchPageCallback,
    required this.getUsernameCallback,
    // required this.getAgeCallback,
    required this.getDateOfBirthCallback,
    required this.getHeightCallback,
    required this.getWeightCallback,
    required this.getEmailCallback,
    required this.getPasswordCallback,
  }) : super(key: key);

  @override
  State<SignUpPassword> createState() => _SignUpPasswordState();
}

class _SignUpPasswordState extends State<SignUpPassword>
    with AutomaticKeepAliveClientMixin<SignUpPassword> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordValid = false;
  final RegExp _passwordRegExp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_\-+=]).{8,63}$');
  late final int _pageIndex = widget.pageIndex;
  late final Function _inputCallback = widget.inputCallback;
  late final Function _switchPageCallback = widget.switchPageCallback;
  late final Function _getUsernameCallback = widget.getUsernameCallback;
  // late final Function _getAgeCallback = widget.getAgeCallback;
  late final Function _getDateOfBirthCallback = widget.getDateOfBirthCallback;
  late final Function _getHeightCallback = widget.getHeightCallback;
  late final Function _getWeightCallback = widget.getWeightCallback;
  late final Function _getEmailCallback = widget.getEmailCallback;
  late final Function _getPasswordCallback = widget.getPasswordCallback;

  @override
  bool get wantKeepAlive => true;

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

  @override
  void didUpdateWidget(covariant SignUpPassword oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
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
        // alignment: Alignment.center,
        actions: <Widget>[
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0), // Set borderRadius to 0
                    ),
                  ),
                ),
                child: const Text("Cancel"),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0), // Set borderRadius to 0
                    ),
                  ),
                ),
                child: const Text("Login"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _createUser() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreatingUser(
          email: _getEmailCallback(),
          password: _getPasswordCallback(),
          username: _getUsernameCallback(),
          // age: _getAgeCallback(),
          dateOfBirth: _getDateOfBirthCallback(),
          height: _getHeightCallback(),
          weight: _getWeightCallback(),
        ),
      ),
    );
    // FirebaseAuth.instance
    //     .createUserWithEmailAndPassword(
    //         email: _getEmailCallback()!, password: _getPasswordCallback()!)
    //     .then(
    //   (responseData) async {
    //     // await FirebaseAuth.instance.signOut();
    //     // Navigator.of(context).popUntil(ModalRoute.withName("/"));
    //     FirebaseService.createUserOnSignup(
    //       user: responseData.user!,
    //       username: _getUsernameCallback(),
    //       age: _getAgeCallback(),
    //       height: _getHeightCallback(),
    //       weight: _getWeightCallback(),
    //       email: _getEmailCallback(),
    //     ).then((_) {
    //       FocusManager.instance.primaryFocus?.unfocus();
    //       Navigator.of(context).popUntil(ModalRoute.withName("/"));
    //       // Navigator.of(context).pop({
    //       //   'email': _getEmailCallback(),
    //       //   'password': _getPasswordCallback()
    //       // });
    //     });
    //   },
    // ).onError(
    //   (error, stackTrace) {
    //     if (error is FirebaseAuthException) {
    //       if (error.code == 'email-already-in-use') {
    //         showAlertDialog(context, "There is already an account with this email address",
    //             "${_getEmailCallback()} is already in use. Login to continue using HealthCompanion.");
    //       }
    //     }
    //   },
    // );
  }

  Color get _passwordColor => _passwordController.text.isEmpty
      ? Colors.grey
      : _isPasswordValid
          ? Colors.green
          : Colors.red;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 125.0),
          //   child: Text(
          //     "Page ${_pageIndex + 1} / 4",
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          const SizedBox(
            height: 50,
          ),
          TextField(
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            maxLength: 64,
            onChanged: (value) {
              setState(() {
                if (_passwordRegExp.hasMatch(value)) {
                  _inputCallback(value);
                  _isPasswordValid = true;
                } else {
                  _isPasswordValid = false;
                }
              });
            },
            decoration: InputDecoration(
              errorText:
                  _isPasswordValid || _passwordController.text.isEmpty ? null : 'Invalid password',
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
              suffixIcon: _passwordController.text.isEmpty
                  ? null
                  : _isPasswordValid
                      ? const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
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
          const SizedBox(
            height: 10,
          ),
          const SignUpInfoCard(
            hint:
                "Password must contain at least one uppercase letter, one lowercase letter, one number, one special character and be between 8-64 characters long.",
          ),
          const Expanded(
            child: SizedBox(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      _switchPageCallback(_pageIndex - 1);
                    },
                    // color: _isUsernameValid ? Theme.of(context).primaryColor : Colors.grey,
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  CustomButton(
                    color: _isPasswordValid ? Colors.green : Colors.grey,
                    onPressed: _isPasswordValid
                        ? () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            _createUser();
                          }
                        : null,
                    // color: _isUsernameValid ? Theme.of(context).primaryColor : Colors.grey,
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //     if (FocusScope.of(context).hasFocus) {
                  //       FocusScope.of(context).unfocus();
                  //     }
                  //     _switchPageCallback(_pageIndex - 1);
                  //   },
                  //   icon: Icon(
                  //     Icons.arrow_circle_left,
                  //     size: 48,
                  //     color: Theme.of(context).primaryColor,
                  //   ),
                  // ),
                  // IconButton(
                  //   onPressed: _isPasswordValid ? _createUser : null,
                  //   icon: Icon(
                  //     Icons.create,
                  //     size: 48,
                  //     color: _isPasswordValid ? Colors.green : Colors.grey,
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
