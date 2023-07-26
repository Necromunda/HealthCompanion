import 'package:flutter/material.dart';
import 'package:health_companion/widgets/signup_info_card.dart';

import 'custom_button.dart';

class SignUpUsername extends StatefulWidget {
  final int pageIndex;
  final Function inputCallback;
  final Function switchPageCallback;

  const SignUpUsername({
    Key? key,
    required this.pageIndex,
    required this.inputCallback,
    required this.switchPageCallback,
  }) : super(key: key);

  @override
  State<SignUpUsername> createState() => _SignUpUsernameState();
}

class _SignUpUsernameState extends State<SignUpUsername>
    with AutomaticKeepAliveClientMixin<SignUpUsername> {
  final TextEditingController _usernameController = TextEditingController();
  bool _isUsernameValid = false;
  final RegExp _usernameRegExp = RegExp(r'^[a-zA-Z][a-zA-Z0-9]{2,29}$');
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
  void didUpdateWidget(covariant SignUpUsername oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Color get _usernameColor => _usernameController.text.isEmpty
      ? Colors.grey
      : _isUsernameValid
          ? Colors.green
          : Colors.red;

  Widget get _usernameTextField => TextField(
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        controller: _usernameController,
        keyboardType: TextInputType.text,
        maxLength: 30,
        onChanged: (value) {
          setState(() {
            _isUsernameValid = _usernameRegExp.hasMatch(value);
            if (_isUsernameValid) {
              _inputCallback(value);
            }
          });
        },
        decoration: InputDecoration(
          counterText: "",
          hintText: "Username",
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
              color: _usernameController.text.isEmpty
                  ? null
                  : _isUsernameValid
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
              child: Icon(Icons.person,
                  size: 30,
                  color: _usernameController.text.isEmpty
                      ? Colors.black87
                      : _isUsernameValid
                          ? Colors.white
                          : Colors.black87),
            ),
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
            height: 50.0,
          ),
          _usernameTextField,
          const SizedBox(
            height: 20,
          ),
          // TextField(
          //   controller: _usernameController,
          //   keyboardType: TextInputType.text,
          //   maxLength: 30,
          //   onChanged: (value) {
          //     setState(() {
          //       if (_usernameRegExp.hasMatch(value)) {
          //         _isUsernameValid = true;
          //         _inputCallback(value);
          //       } else {
          //         _isUsernameValid = false;
          //       }
          //     });
          //   },
          //   decoration: InputDecoration(
          //     errorText: _isUsernameValid || _usernameController.text.isEmpty
          //         ? null
          //         : 'Invalid username',
          //     errorBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: _usernameController.text.isEmpty
          //             ? Colors.grey
          //             : Colors.red,
          //         width: 2.0,
          //       ),
          //     ),
          //     focusedBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: _usernameColor,
          //         width: 2.0,
          //       ),
          //     ),
          //     enabledBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: _usernameColor,
          //         width: 2.0,
          //       ),
          //     ),
          //     prefixIcon: Icon(
          //       Icons.person,
          //       color: _usernameColor,
          //     ),
          //     suffixIcon: _usernameController.text.isEmpty
          //         ? null
          //         : _isUsernameValid
          //             ? const Icon(
          //                 Icons.check,
          //                 color: Colors.green,
          //               )
          //             : const Icon(
          //                 Icons.close,
          //                 color: Colors.red,
          //               ),
          //     hintText: "Username",
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
                "Username must start with a letter, contain only letters and numbers & be between 3 - 30 characters long.\nUsername is not used for sign in.",
          ),
          const Expanded(
            child: SizedBox(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CustomButton(
                onPressed: _isUsernameValid
                    ? () {
                        // if (FocusScope.of(context).hasFocus) {
                        //   FocusScope.of(context).unfocus();
                        // }
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
              // child: IconButton(
              //   disabledColor: Colors.grey,
              //   onPressed: _isUsernameValid
              //       ? () {
              //           if (FocusScope.of(context).hasFocus) {
              //             FocusScope.of(context).unfocus();
              //           }
              //           _switchPageCallback(_pageIndex + 1);
              //         }
              //       : null,
              //   icon: Icon(
              //     Icons.arrow_circle_right,
              //     color: _isUsernameValid
              //         ? Theme.of(context).primaryColor
              //         : Colors.grey,
              //     size: 48,
              //   ),
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
