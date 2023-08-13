import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:health_companion/util.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({Key? key}) : super(key: key);

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  late final TextEditingController _passwordController;
  late bool _isPasswordValid, _obscureText;
  late final RegExp _passwordRegExp;

  @override
  void initState() {
    _isPasswordValid = false;
    _obscureText = true;
    _passwordController = TextEditingController();
    _passwordRegExp = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_\-+=]).{8,63}$');
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
    _passwordController.dispose();
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
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: _obscureText,
            maxLength: 64,
            onChanged: (value) {
              setState(() {
                _isPasswordValid = _passwordRegExp.hasMatch(value);
              });
            },
            style: TextStyle(
              color: Util.isDark(context) ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
              counterText: "",
              hintText: AppLocalizations.of(context)!.password,
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
                  color: _passwordController.text.isEmpty
                      ? null
                      : _isPasswordValid
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
                    Icons.key,
                    size: 30,
                  ),
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  // color: Colors.black87,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: Text(AppLocalizations.of(context)!.cancel),
                onPressed: () {
                  Navigator.of(context).pop();
                  _passwordController.clear();
                  _isPasswordValid = false;
                },
              ),
              if (_isPasswordValid)
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop(_passwordController.text);
                    _passwordController.clear();
                    _isPasswordValid = false;
                  },
                ),
            ],
          )
        ],
      ),
    );
  }
}
