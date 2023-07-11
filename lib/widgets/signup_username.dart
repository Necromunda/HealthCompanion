import 'package:flutter/material.dart';

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
  final RegExp _usernameRegExp = RegExp(r'^[a-zA-Z][a-zA-Z0-9]{1,29}$');
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
            controller: _usernameController,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              setState(() {
                if (_usernameRegExp.hasMatch(value)) {
                  _inputCallback(value);
                  _isUsernameValid = true;
                } else {
                  _isUsernameValid = false;
                }
              });
            },
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2.0),
              ),
              prefixIcon: const Icon(
                Icons.person,
                color: Colors.grey,
              ),
              suffixIcon: _usernameController.text.isEmpty
                  ? null
                  : _isUsernameValid
                      ? const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
              hintText: "Username",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide:
                      const BorderSide(width: 1, style: BorderStyle.none)),
            ),
          ),
          const Card(
            elevation: 1,
            margin: EdgeInsets.only(top: 25.0),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Username must start with a letter, contain only letters and numbers & be between 2-30 characters long.\nUsername is not used for sign in.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: IconButton(
                  disabledColor: Colors.grey,
                  onPressed: _isUsernameValid
                      ? () {
                          if (FocusScope.of(context).hasFocus) {
                            FocusScope.of(context).unfocus();
                          }
                          _switchPageCallback(1);
                        }
                      : null,
                  icon: Icon(
                    Icons.arrow_circle_right_outlined,
                    color: _isUsernameValid
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
