import 'package:flutter/material.dart';
import 'package:health_companion/widgets/signup_info_card.dart';

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

  Color get _getColor => _usernameController.text.isEmpty
      ? Colors.grey
      : _isUsernameValid
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
            controller: _usernameController,
            keyboardType: TextInputType.text,
            maxLength: 30,
            onChanged: (value) {
              setState(() {
                if (_usernameRegExp.hasMatch(value)) {
                  _isUsernameValid = true;
                  _inputCallback(value);
                } else {
                  _isUsernameValid = false;
                }
              });
            },
            decoration: InputDecoration(
              errorText: _isUsernameValid || _usernameController.text.isEmpty
                  ? null
                  : 'Invalid username',
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: _usernameController.text.isEmpty
                      ? Colors.grey
                      : Colors.red,
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
                Icons.person,
                color: _getColor,
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
                borderSide: const BorderSide(
                  width: 2.0,
                  style: BorderStyle.none,
                ),
              ),
            ),
          ),
          const SignUpInfoCard(
            hint:
                "Username must start with a letter, contain only letters and numbers & be between 2-30 characters long.\nUsername is not used for sign in.",
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
                          _switchPageCallback(_pageIndex + 1);
                        }
                      : null,
                  icon: Icon(
                    Icons.arrow_circle_right,
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
