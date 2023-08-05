import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/models/appuser_model.dart';
import 'package:health_companion/screens/loading_screen.dart';
import 'package:health_companion/services/firebase_service.dart';
import 'package:health_companion/widgets/creating_user.dart';
import 'package:health_companion/widgets/signup_info_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../screens/signin_screen.dart';
import '../util.dart';
import 'custom_button.dart';

class SignUpPassword extends StatefulWidget {
  final int pageIndex;
  final Function inputCallback,
      switchPageCallback,
      getUsernameCallback,
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
  // bool _isPasswordValid = false;
  bool _isPasswordValid = true;
  bool _obscureText = true;
  final RegExp _passwordRegExp = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_\-+=]).{8,63}$');
  late final int _pageIndex = widget.pageIndex;
  late final Function _inputCallback = widget.inputCallback;
  late final Function _switchPageCallback = widget.switchPageCallback;
  late final Function _getUsernameCallback = widget.getUsernameCallback;
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
                      borderRadius:
                          BorderRadius.circular(5.0), // Set borderRadius to 0
                    ),
                  ),
                ),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(5.0), // Set borderRadius to 0
                    ),
                  ),
                ),
                child: Text(AppLocalizations.of(context)!.signIn),
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
          // email: _getEmailCallback(),
          // password: _getPasswordCallback(),
          // username: _getUsernameCallback(),
          // dateOfBirth: _getDateOfBirthCallback(),
          // height: _getHeightCallback(),
          // weight: _getWeightCallback(),
          email: 'test000@gmail.com',
          password: 'Test000!',
          username: 'test',
          dateOfBirth: DateTime(2000,3,6),
          height: 180,
          weight: 80,
        ),
      ),
    );
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
            if (_isPasswordValid) {
              _inputCallback(value);
            }
          });
        },
        style: TextStyle(
          color: Util.isDark(context) ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
          counterText: "",
          hintText: AppLocalizations.of(context)!.password,
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
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          _passwordTextField,
          const SizedBox(
            height: 20,
          ),
          SignUpInfoCard(
            hint: AppLocalizations.of(context)!.signUpPasswordInfo,
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
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
