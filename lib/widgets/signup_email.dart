import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/widgets/signup_info_card.dart';

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

  Color get _getColor => _emailController.text.isEmpty
      ? Colors.grey
      : _isEmailValid
          ? Colors.green
          : Colors.red;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 125.0),
            child: Text(
              "Page ${_pageIndex + 1} / 4",
              textAlign: TextAlign.center,
            ),
          ),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              setState(() {
                if (EmailValidator.validate(value)) {
                  _inputCallback(value);
                  _isEmailValid = true;
                } else {
                  _isEmailValid = false;
                }
              });
            },
            decoration: InputDecoration(
              errorText: _isEmailValid || _emailController.text.isEmpty
                  ? null
                  : 'Invalid email',
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      _emailController.text.isEmpty ? Colors.grey : Colors.red,
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: _getColor,
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: _getColor,
                  width: 2.0,
                ),
              ),
              prefixIcon: Icon(
                Icons.email,
                color: _getColor,
              ),
              suffixIcon: _emailController.text.isEmpty
                  ? null
                  : _isEmailValid
                      ? const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
              hintText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  width: 2.0,
                  style: BorderStyle.none,
                ),
              ),
            ),
          ),
          const SignUpInfoCard(
            hint:
                "Email must be a valid email address.\nEmail is used for sign in.",
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (FocusScope.of(context).hasFocus) {
                          FocusScope.of(context).unfocus();
                        }
                        _switchPageCallback(_pageIndex - 1);
                      },
                      icon: Icon(
                        Icons.arrow_circle_left,
                        size: 48,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    IconButton(
                      onPressed: _isEmailValid
                          ? () {
                              if (FocusScope.of(context).hasFocus) {
                                FocusScope.of(context).unfocus();
                              }
                              _switchPageCallback(_pageIndex + 1);
                            }
                          : null,
                      icon: Icon(
                        Icons.arrow_circle_right,
                        size: 48,
                        color: _isEmailValid
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
