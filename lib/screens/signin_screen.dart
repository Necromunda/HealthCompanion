import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:health_companion/models/appuser_model.dart';
import 'package:health_companion/screens/forgot_password_screen.dart';
import 'package:health_companion/screens/signup_screen.dart';
import 'package:health_companion/services/firebase_service.dart';

import '../widgets/pagecontainer.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  final RegExp _passwordRegExp = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_\-+=]).{8,63}$');

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
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then(
      (responseData) {
        print("VALUE : $responseData");
        FirebaseService.createUser(responseData.user!.uid).then(
          (appUser) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PageContainer(
                user: appUser ?? AppUser(),
              ),
            ),
          ),
        );
      },
    ).catchError(
      (error) {
        print(error);
      },
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

    Map<String, dynamic>? obj = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUp(),
      ),
    );
    print(obj);
    if (obj != null) {
      _login(obj['email'], obj['password']);
    }
  }

  void _clearInput() {
    setState(() {
      _emailController.clear();
      _passwordController.clear();
      _isEmailValid = false;
      _isPasswordValid = false;
    });
    // Focus.of(context).unfocus();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        // leading: IconButton(
        //   onPressed: () => Navigator.of(context).pop(),
        //   icon: const Icon(Icons.close),
        //   color: Colors.black,
        // ),
      ),
      body: Center(
        child: Padding(
          // padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Image.asset("assets/images/placeholder_logo.png"),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => setState(() {
                    _isEmailValid =
                        EmailValidator.validate(value) ? true : false;
                  }),
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _emailController.text.isEmpty
                            ? Colors.grey
                            : Colors.red,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _emailColor,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _emailColor,
                        width: 2.0,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.email,
                      color: _emailColor,
                    ),
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        width: 2.0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TextField(
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
                        color: _passwordController.text.isEmpty
                            ? Colors.grey
                            : Colors.red,
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
                  child: const Text("Log in"),
                ),
              ),
              TextButton(
                onPressed: _forgotPasswordButtonHandler,
                child: const Text(
                  "Forgot password?",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: _createAccountButtonHandler,
                child: const Text(
                  "Create account",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
