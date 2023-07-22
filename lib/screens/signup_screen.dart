import 'package:flutter/material.dart';
import 'package:health_companion/models/appuser_model.dart';
import 'package:health_companion/services/firebase_service.dart';
import 'package:health_companion/widgets/signup_email.dart';
import 'package:health_companion/widgets/signup_password.dart';
import 'package:health_companion/widgets/signup_background_info.dart';
import 'package:health_companion/widgets/signup_username.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final PageController _pageController = PageController();
  String? _username, _email, _password;
  int? _age, _height;
  double? _weight;
  int _selectedIndex = 0;

  void _switchPage(int index) {
    print("Switch page to $index");
    print("username: $_username\nAge: $_age\nHeight: $_height\nWeight: $_weight\nEmail: $_email\nPassword: $_password");
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

  void _setAgeCallback(int age) {
    setState(() {
      _age = age;
    });
  }

  void _setHeightCallback(int height) {
    setState(() {
      _height = height;
    });
  }

  void _setWeightCallback(double weight) {
    setState(() {
      _weight = weight;
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

  String? _getUsername() => _username;

  String? _getEmail() => _email;

  String? _getPassword() => _password;

  int? _getAge() => _age;

  int? _getHeight() => _height;

  double? _getWeight() => _weight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          SignUpBackgroundInfo(
            pageIndex: 1,
            inputCallbackAge: _setAgeCallback,
            inputCallbackHeight: _setHeightCallback,
            inputCallbackWeight: _setWeightCallback,
            switchPageCallback: _switchPage,
          ),
          SignUpEmail(
            pageIndex: 2,
            inputCallback: _setEmailCallback,
            switchPageCallback: _switchPage,
          ),
          SignUpPassword(
            pageIndex: 3,
            inputCallback: _setPasswordCallback,
            switchPageCallback: _switchPage,
            getUsernameCallback: _getUsername,
            getAgeCallback: _getAge,
            getHeightCallback: _getHeight,
            getWeightCallback: _getWeight,
            getEmailCallback: _getEmail,
            getPasswordCallback: _getPassword,
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
