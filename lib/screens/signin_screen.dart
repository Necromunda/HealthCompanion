import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:health_companion/util.dart';
import 'package:health_companion/screens/signup_screen.dart';
import 'package:health_companion/screens/loading_screen.dart';
import 'package:health_companion/screens/forgot_password_screen.dart';

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
                        message: AppLocalizations.of(context)!
                            .incorrectEmailAndOrPassword,
                      ),
                    );
                    break;
                  case "invalid-email":
                    Future(
                      () => Util.showNotification(
                        context: context,
                        message: AppLocalizations.of(context)!.incorrectEmail,
                      ),
                    );
                    break;
                  case "user-not-found":
                    Future(
                      () => Util.showNotification(
                        context: context,
                        message:
                            AppLocalizations.of(context)!.userNotFoundWithEmail,
                      ),
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
            return LoadingScreen(
              message: AppLocalizations.of(context)!.loggingIn,
            );
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUp(),
      ),
    );
  }

  void _clearInput() {
    setState(() {
      _emailController.clear();
      _passwordController.clear();
      _isEmailValid = false;
      _isPasswordValid = false;
    });
  }

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
          hintText: AppLocalizations.of(context)!.hintEmail,
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

  Color get authButtonColor => Util.isDark(context)
      ? Theme.of(context).colorScheme.onTertiary
      : Theme.of(context).colorScheme.tertiary;

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
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset("assets/images/HealthCompanion-Logo2.png"),
              ),
              const SizedBox(
                height: 100,
              ),
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
                    backgroundColor: authButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.0),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.signIn,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: _forgotPasswordButtonHandler,
                child: Text(
                  AppLocalizations.of(context)!.forgotPassword,
                  style: TextStyle(
                      color: Util.isDark(context) ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: _createAccountButtonHandler,
                child: Text(
                  AppLocalizations.of(context)!.createAccount,
                  style: TextStyle(
                      color: Util.isDark(context) ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
