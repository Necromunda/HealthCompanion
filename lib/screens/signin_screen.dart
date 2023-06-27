import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:health_companion/screens/forgot_password_screen.dart';
import 'package:health_companion/screens/signup_screen.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isEmailValid = false;

  void _loginButtonHandler() {
    print(_emailController.text);
    print(_passwordController.text.isEmpty);
  }

  void _forgotPasswordButtonHandler() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPassword(),
      ),
    );
  }

  void _createAccountButtonHandler() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUp(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.center,
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
                  onChanged: (value) {
                    setState(() {
                      _isEmailValid =
                          EmailValidator.validate(value) ? true : false;
                    });
                  },
                  decoration: InputDecoration(
                    // labelText: _isEmailValid ? null : "Invalid email",
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      // borderRadius: BorderRadius.circular(15.0),
                    ),
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.grey,
                    ),
                    hintText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                            width: 1, style: BorderStyle.none)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TextField(
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      // borderRadius: BorderRadius.circular(15.0),
                    ),
                    prefixIcon: const Icon(
                      Icons.password,
                      color: Colors.grey,
                    ),
                    // label: Text("Password"),
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide:
                          const BorderSide(width: 1, style: BorderStyle.none),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isEmailValid ? _loginButtonHandler : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.0),
                      // side: BorderSide(color: Colors.red)
                    ),
                  ),
                  child: const Text("Log in"),
                ),
              ),
              TextButton(
                onPressed: _forgotPasswordButtonHandler,
                child: const Text(
                  "Forgot password?",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              TextButton(
                onPressed: _createAccountButtonHandler,
                child: const Text(
                  "Create account",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
