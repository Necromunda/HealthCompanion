import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 175.0),
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
              // labelText: _isEmailValid ? null : "Invalid email",
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2.0),
                // borderRadius: BorderRadius.circular(15.0),
              ),
              prefixIcon: const Icon(
                Icons.email,
                color: Colors.grey,
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
                  borderSide:
                      const BorderSide(width: 1, style: BorderStyle.none)),
            ),
          ),
          const SizedBox(
            width: double.infinity,
            child: Card(
              elevation: 1,
              margin: EdgeInsets.only(top: 25.0),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Email must be a valid email address.\nEmail is used for sign in.",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
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
                        FocusScope.of(context).unfocus();
                        _switchPageCallback(0);
                      },
                      icon: Icon(
                        Icons.arrow_circle_left_outlined,
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
                              _switchPageCallback(2);
                            }
                          : null,
                      icon: Icon(
                        Icons.arrow_circle_right_outlined,
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
