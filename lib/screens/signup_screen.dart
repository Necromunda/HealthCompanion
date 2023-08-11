import 'package:flutter/material.dart';

import 'package:health_companion/widgets/signup_email.dart';
import 'package:health_companion/widgets/signup_password.dart';
import 'package:health_companion/widgets/signup_username.dart';
import 'package:health_companion/widgets/signup_background_info.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final PageController _pageController = PageController(initialPage: 3);
  String? _username, _email, _password;
  DateTime? _dateOfBirth;
  double? _height, _weight;
  int _selectedIndex = 0;

  @override
  void initState() {
    print("Signup screen init");
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
    super.dispose();
  }

  void _switchPage(int index) {
    print("Switch page to $index");
    print(
        "username: $_username\nDate of Birth: $_dateOfBirth\nHeight: $_height\nWeight: $_weight\nEmail: $_email\nPassword: $_password");
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

  void _setDateOBirthCallback(DateTime dateOfBirth) {
    setState(() {
      _dateOfBirth = dateOfBirth;
    });
  }

  void _setHeightCallback(double height) {
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

  DateTime? _getDateOfBirth() => _dateOfBirth;

  double? _getHeight() => _height;

  double? _getWeight() => _weight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
        centerTitle: true,
        title: Text(
          "Page ${_selectedIndex + 1} / 4",
          style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
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
            inputCallbackDateOfBirth: _setDateOBirthCallback,
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
            getDateOfBirthCallback: _getDateOfBirth,
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
