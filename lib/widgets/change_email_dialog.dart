import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../util.dart';

class ChangeEmailDialog extends StatefulWidget {
  const ChangeEmailDialog({Key? key}) : super(key: key);

  @override
  State<ChangeEmailDialog> createState() => _ChangeEmailDialogState();
}

class _ChangeEmailDialogState extends State<ChangeEmailDialog> {
  late final TextEditingController _emailController;
  late bool _isEmailValid;

  @override
  void initState() {
    _isEmailValid = false;
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            // inputFormatters: [FilteringTextInputFormatter.allow(_emailRegexp)],
            maxLength: 99,
            onChanged: (value) {
              setState(() {
                bool isTldValid = value.split(".").last.length >= 2;
                _isEmailValid = (EmailValidator.validate(value) && isTldValid)
                    ? true
                    : false;
              });
            },
            style: TextStyle(
              color: Util.isDark(context) ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
                counterText: "",
                hintText: "Email",
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
                        offset:
                            const Offset(2, 0), // changes position of shadow
                      ),
                      BoxShadow(
                        // color: const Color(0XDEDEDEDE).withOpacity(1),
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        spreadRadius: 0,
                        offset:
                            const Offset(1, 0), // changes position of shadow
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _emailController.clear();
                  _isEmailValid = false;
                },
              ),
              if (_isEmailValid)
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop(_emailController.text);
                    _emailController.clear();
                    _isEmailValid = false;
                  },
                ),
            ],
          )
        ],
      ),
    );
  }
}
