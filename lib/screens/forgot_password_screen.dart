import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:health_companion/util.dart';
import 'package:health_companion/widgets/forgot_password_instructions.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  bool _didPressButton = false;
  bool _isEmailValid = false;

  void _forgotPasswordButtonHandler() {
    setState(() {
      _didPressButton = true;
    });
  }

  Color get _emailColor => _emailController.text.isEmpty
      ? Colors.grey
      : _isEmailValid
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

  Color get sendButtonColor => Util.isDark(context)
      ? Theme.of(context).colorScheme.onTertiary
      : Theme.of(context).colorScheme.tertiary;

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
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 125, left: 30, right: 30),
          child: _didPressButton
              ? ForgotPasswordInstructions(email: _emailController.text)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        AppLocalizations.of(context)!.forgotPassword,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        AppLocalizations.of(context)!.forgotPasswordInfo,
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _emailTextField,
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed:
                            _isEmailValid ? _forgotPasswordButtonHandler : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: sendButtonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1.0),
                            // side: BorderSide(color: Colors.red)
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.send,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // const Expanded(flex: 2, child: SizedBox())
                  ],
                ),
        ),
      ),
    );
  }
}
