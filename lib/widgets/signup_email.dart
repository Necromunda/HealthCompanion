import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/widgets/signup_info_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../util.dart';
import 'custom_button.dart';

class SignUpEmail extends StatefulWidget {
  final int pageIndex;
  final Function inputCallback;
  final Function switchPageCallback;

  const SignUpEmail({
    Key? key,
    required this.pageIndex,
    required this.inputCallback,
    required this.switchPageCallback,
  }) : super(key: key);

  @override
  State<SignUpEmail> createState() => _SignUpEmailState();
}

class _SignUpEmailState extends State<SignUpEmail>
    with AutomaticKeepAliveClientMixin<SignUpEmail> {
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = false;
  late final _pageIndex = widget.pageIndex;
  late final _inputCallback = widget.inputCallback;
  late final _switchPageCallback = widget.switchPageCallback;

  @override
  bool get wantKeepAlive => true;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didUpdateWidget(covariant SignUpEmail oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Widget get _emailTextField => TextField(
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        // inputFormatters: [FilteringTextInputFormatter.allow(_emailRegexp)],
        maxLength: 99,
        onChanged: (value) {
          setState(() {
            bool isTldValid = value.split(".").last.length >= 2;
            _isEmailValid =
                (EmailValidator.validate(value) && isTldValid) ? true : false;
            if (_isEmailValid) {
              _inputCallback(value);
            }
          });
        },
        style: TextStyle(
          color: Util.isDark(context) ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
            counterText: "",
            hintText: AppLocalizations.of(context)!.email,
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
                    offset: const Offset(1, 0), // changes position of shadow
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
            suffixIcon: const SizedBox()),
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          const SizedBox(
            height: 50.0,
          ),
          _emailTextField,
          const SizedBox(
            height: 20.0,
          ),
          SignUpInfoCard(
            hint: AppLocalizations.of(context)!.signUpEmailInfo,
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
                    onPressed: _isEmailValid
                        ? () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            _switchPageCallback(_pageIndex + 1);
                          }
                        : null,
                    child: const Icon(
                      Icons.arrow_forward,
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
