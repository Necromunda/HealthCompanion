import 'package:flutter/material.dart';

class SignUpPassword extends StatefulWidget {
  final int pageIndex;
  final Function inputCallback;
  final Function switchPageCallback;

  const SignUpPassword({
    Key? key,
    required this.pageIndex,
    required this.inputCallback,
    required this.switchPageCallback,
  }) : super(key: key);

  @override
  State<SignUpPassword> createState() => _SignUpPasswordState();
}

class _SignUpPasswordState extends State<SignUpPassword>
    with AutomaticKeepAliveClientMixin<SignUpPassword> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordValid = false;
  RegExp _passwordRegExp = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_\-+=]).{8,63}$');
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
  void didUpdateWidget(covariant SignUpPassword oldWidget) {
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
              "Page ${_pageIndex + 1} / 3",
              textAlign: TextAlign.center,
            ),
          ),
          TextField(
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            maxLength: 64,
            onChanged: (value) {
              setState(() {
                if (_passwordRegExp.hasMatch(value)) {
                  _inputCallback(value);
                  _isPasswordValid = true;
                } else {
                  _isPasswordValid = false;
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
                Icons.password,
                color: Colors.grey,
              ),
              suffixIcon: _passwordController.text.isEmpty
                  ? null
                  : _isPasswordValid
                      ? const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
              hintText: "Password",
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
                  "Password must contain at least one uppercase letter, one lowercase letter, one number, one special character and be between 8-64 characters long.",
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
                        _switchPageCallback(1);
                      },
                      icon: const Icon(
                        Icons.arrow_circle_left_outlined,
                        size: 48,
                        color: Colors.red,
                      ),
                    ),
                    IconButton(
                      onPressed: _isPasswordValid
                          ? () {
                              FocusScope.of(context).unfocus();
                              Navigator.of(context).pop();
                            }
                          : null,
                      icon: Icon(
                        Icons.create,
                        size: 48,
                        color: _isPasswordValid ? Colors.green : Colors.grey,
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
