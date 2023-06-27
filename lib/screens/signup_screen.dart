import 'package:flutter/material.dart';
import 'package:health_companion/widgets/signup_email.dart';
import 'package:health_companion/widgets/signup_password.dart';
import 'package:health_companion/widgets/signup_username.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final PageController _pageController = PageController();
  String? _username;
  String? _email;
  String? _password;
  int _selectedIndex = 0;

  void _switchPage(int index) {
    print("Switch page to $index");
    print("username: $_username\nEmail: $_email\nPassword: $_password");
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _setUsernameCallback(String username) {
    setState(() {
      _username = username;
    });
  }

  void _setEmailCallback(String email) {
    setState(() {
      _email = email;
    });
  }

  void _setPasswordCallback(String password) {
    setState(() {
      _password = password;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
          color: Colors.black,
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          SignUpUsername(
            pageIndex: 0,
            inputCallback: _setUsernameCallback,
            switchPageCallback: _switchPage,
          ),
          SignUpEmail(
            pageIndex: 1,
            inputCallback: _setEmailCallback,
            switchPageCallback: _switchPage,
          ),
          SignUpPassword(
            pageIndex: 2,
            inputCallback: _setPasswordCallback,
            switchPageCallback: _switchPage,
          ),
        ],
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
