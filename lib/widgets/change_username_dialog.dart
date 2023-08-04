import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../util.dart';

class ChangeUsernameDialog extends StatefulWidget {
  const ChangeUsernameDialog({Key? key}) : super(key: key);

  @override
  State<ChangeUsernameDialog> createState() => _ChangeUsernameDialogState();
}

class _ChangeUsernameDialogState extends State<ChangeUsernameDialog> {
  late final TextEditingController _usernameController;
  late bool _isUsernameValid;
  late final RegExp _usernameRegExp;

  @override
  void initState() {
    _isUsernameValid = false;
    _usernameController = TextEditingController();
    _usernameRegExp = RegExp(r'^[a-zA-Z][a-zA-Z0-9]{2,29}$');
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
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width,
      // height: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            controller: _usernameController,
            keyboardType: TextInputType.text,
            maxLength: 30,
            onChanged: (value) {
              setState(() {
                _isUsernameValid = _usernameRegExp.hasMatch(value);
                if (_isUsernameValid) {}
              });
            },
            style: TextStyle(
              color: Util.isDark(context) ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
              counterText: "",
              hintText: AppLocalizations.of(context)!.username,
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
                    Icons.person,
                    size: 30,
                  ),
                ),
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
                  _usernameController.clear();
                  _isUsernameValid = false;
                },
              ),
              if (_isUsernameValid)
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop(_usernameController.text);
                    _usernameController.clear();
                    _isUsernameValid = false;
                  },
                ),
            ],
          )
        ],
      ),
    );
  }
}
