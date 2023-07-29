import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:health_companion/models/appuser_model.dart';
import 'package:health_companion/screens/forgot_password_screen.dart';
import 'package:health_companion/screens/signup_screen.dart';
import 'package:health_companion/services/firebase_service.dart';
import 'package:health_companion/util.dart';

import '../widgets/pagecontainer.dart';
import 'loading_screen.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late final TextEditingController _emailController, _passwordController;
  late bool _isEmailValid, _isPasswordValid, _obscureText;
  late final RegExp _passwordRegExp;

  @override
  void initState() {
    print("Signin init");
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _isEmailValid = false;
    _isPasswordValid = false;
    _obscureText = true;
    _passwordRegExp = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_\-+=]).{8,63}$');
    setState(() {
      _emailController.text = "johannes.rantapaa@gmail.com";
      _passwordController.text = "Johannes00!!";
    });
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _showAlertDialog(
      BuildContext context, String title, String message) {
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
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _login(String email, String password) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FutureBuilder(
          future: FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              Future(() => Navigator.of(context).pop());
              if (snapshot.error is FirebaseAuthException) {
                FirebaseAuthException firebaseError =
                    snapshot.error as FirebaseAuthException;
                switch (firebaseError.code) {
                  case "wrong-password":
                    Future(
                      () => Util.showNotification(
                          context: context,
                          message: "Incorrect email and/or password."),
                    );
                    break;
                  case "invalid-email":
                    Future(
                      () => Util.showNotification(
                          context: context, message: "Email is not valid"),
                    );
                    break;
                  case "user-not-found":
                    Future(
                      () => Util.showNotification(
                          context: context,
                          message:
                              "Could not find a user with that email address."),
                    );
                    break;
                }
              }
            }
            if (snapshot.hasData) {
              print("VALUE : ${snapshot.data}");
              // return const PageContainer();
              Future(() =>
                  Navigator.of(context).popUntil(ModalRoute.withName('/')));
            }
            return const LoadingScreen(message: "Logging in");
          },
        ),
      ),
    );
  }

  void _loginButtonHandler() async {
    _login(_emailController.text, _passwordController.text);
  }

  void _forgotPasswordButtonHandler() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPassword(),
      ),
    );
  }

  void _createAccountButtonHandler() async {
    _clearInput();

    // Map<String, dynamic>? obj = await Navigator.push(
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUp(),
      ),
    );
    // print(obj);
    // if (obj != null) {
    //   _login(obj['email'], obj['password']);
    // }
  }

  void _clearInput() {
    setState(() {
      _emailController.clear();
      _passwordController.clear();
      _isEmailValid = false;
      _isPasswordValid = false;
    });
  }

  Color get _emailColor => _emailController.text.isEmpty
      ? Colors.grey
      : _isEmailValid
          ? Colors.green
          : Colors.red;

  Color get _passwordColor => _passwordController.text.isEmpty
      ? Colors.grey
      : _isPasswordValid
          ? Colors.green
          : Colors.red;

  Widget get _emailTextField => TextField(
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        maxLength: 99,
        onChanged: (value) {
          setState(() {
            bool isTLDValid = value.split(".").last.length >= 2;
            _isEmailValid =
                (EmailValidator.validate(value) && isTLDValid) ? true : false;
          });
        },
        style: TextStyle(
          color: Util.isDark(context) ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
          counterText: "",
          hintText: "Email",
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
              color: _emailController.text.isEmpty
                  ? null
                  : _isEmailValid
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
                  offset: const Offset(1, 0.5), // changes position of shadow
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.email,
                size: 30,
              ),
            ),
          ),
          suffixIcon: const SizedBox(),
        ),
      );

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
                  offset: const Offset(1, 0.5), // changes position of shadow
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
      ),
      body: Center(
        child: Padding(
          // padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Image.asset("assets/images/placeholder_logo.png"),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 10.0),
              //   child:
              //   TextField(
              //     controller: _emailController,
              //     keyboardType: TextInputType.emailAddress,
              //     onChanged: (value) => setState(() {
              //       _isEmailValid =
              //           EmailValidator.validate(value) ? true : false;
              //     }),
              //     decoration: InputDecoration(
              //       errorBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: _emailController.text.isEmpty
              //               ? Colors.grey
              //               : Colors.red,
              //           width: 2.0,
              //         ),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: _emailColor,
              //           width: 2.0,
              //         ),
              //       ),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: _emailColor,
              //           width: 2.0,
              //         ),
              //       ),
              //       prefixIcon: Icon(
              //         Icons.email,
              //         color: _emailColor,
              //       ),
              //       hintText: "Email",
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(5.0),
              //         borderSide: const BorderSide(
              //           width: 2.0,
              //           style: BorderStyle.none,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 10.0),
              //   child: TextField(
              //     controller: _passwordController,
              //     keyboardType: TextInputType.visiblePassword,
              //     obscureText: true,
              //     onChanged: (value) => setState(() {
              //       if (_passwordRegExp.hasMatch(value)) {
              //         _isPasswordValid = true;
              //       } else {
              //         _isPasswordValid = false;
              //       }
              //     }),
              //     decoration: InputDecoration(
              //       errorBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: _passwordController.text.isEmpty
              //               ? Colors.grey
              //               : Colors.red,
              //           width: 2.0,
              //         ),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: _passwordColor,
              //           width: 2.0,
              //         ),
              //       ),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: _passwordColor,
              //           width: 2.0,
              //         ),
              //       ),
              //       prefixIcon: Icon(
              //         Icons.password,
              //         color: _passwordColor,
              //       ),
              //       // label: Text("Password"),
              //       hintText: "Password",
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(5.0),
              //         borderSide: const BorderSide(
              //           width: 2.0,
              //           style: BorderStyle.none,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              _emailTextField,
              const SizedBox(
                height: 10,
              ),
              _passwordTextField,
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _loginButtonHandler,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.0),
                    ),
                  ),
                  child: const Text(
                    "Log in",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: _forgotPasswordButtonHandler,
                child: const Text(
                  "Forgot password?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: _createAccountButtonHandler,
                child: const Text(
                  "Create account",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
