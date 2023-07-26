import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_companion/widgets/signup_info_card.dart';

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

  Color get _emailColor => _emailController.text.isEmpty
      ? Colors.grey
      : _isEmailValid
          ? Colors.green
          : Colors.red;

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
        decoration: InputDecoration(
            counterText: "",
            hintText: "Email",
            contentPadding: EdgeInsets.zero,
            filled: true,
            fillColor: const Color(0XDEDEDEDE),
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
                    color: const Color(0XDEDEDEDE).withOpacity(1),
                    spreadRadius: 0,
                    offset: const Offset(1, 0), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.email,
                    size: 30,
                    color: _emailController.text.isEmpty
                        ? Colors.black87
                        : _isEmailValid
                            ? Colors.white
                            : Colors.black87),
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
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 125.0),
          //   child: Text(
          //     "Page ${_pageIndex + 1} / 4",
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          const SizedBox(
            height: 50.0,
          ),
          _emailTextField,
          const SizedBox(
            height: 20.0,
          ),
          // TextField(
          //   controller: _emailController,
          //   keyboardType: TextInputType.emailAddress,
          //   onChanged: (value) {
          //     setState(() {
          //       _isEmailValid = EmailValidator.validate(value);
          //       _inputCallback(value);
          //     });
          //   },
          //   decoration: InputDecoration(
          //     errorText: _isEmailValid || _emailController.text.isEmpty ? null : 'Invalid email',
          //     errorBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: _emailController.text.isEmpty ? Colors.grey : Colors.red,
          //         width: 2.0,
          //       ),
          //     ),
          //     focusedBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: _emailColor,
          //         width: 2.0,
          //       ),
          //     ),
          //     enabledBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: _emailColor,
          //         width: 2.0,
          //       ),
          //     ),
          //     prefixIcon: Icon(
          //       Icons.email,
          //       color: _emailColor,
          //     ),
          //     suffixIcon: _emailController.text.isEmpty
          //         ? null
          //         : _isEmailValid
          //             ? const Icon(
          //                 Icons.check,
          //                 color: Colors.green,
          //               )
          //             : const Icon(
          //                 Icons.close,
          //                 color: Colors.red,
          //               ),
          //     hintText: "Email",
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(5.0),
          //       borderSide: const BorderSide(
          //         width: 2.0,
          //         style: BorderStyle.none,
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 10.0,
          // ),
          const SignUpInfoCard(
            hint:
                "Email must be a valid email address.\nEmail is used for sign in.",
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
                    // color: _isUsernameValid ? Theme.of(context).primaryColor : Colors.grey,
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
                    // color: _isUsernameValid ? Theme.of(context).primaryColor : Colors.grey,
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //     if (FocusScope.of(context).hasFocus) {
                  //       FocusScope.of(context).unfocus();
                  //     }
                  //     _switchPageCallback(_pageIndex - 1);
                  //   },
                  //   icon: Icon(
                  //     Icons.arrow_circle_left,
                  //     size: 48,
                  //     color: Theme.of(context).primaryColor,
                  //   ),
                  // ),
                  // IconButton(
                  //   onPressed: _isEmailValid
                  //       ? () {
                  //           if (FocusScope.of(context).hasFocus) {
                  //             FocusScope.of(context).unfocus();
                  //           }
                  //           _switchPageCallback(_pageIndex + 1);
                  //         }
                  //       : null,
                  //   icon: Icon(
                  //     Icons.arrow_circle_right,
                  //     size: 48,
                  //     color: _isEmailValid
                  //         ? Theme.of(context).primaryColor
                  //         : Colors.grey,
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
