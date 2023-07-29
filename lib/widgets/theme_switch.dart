import 'package:flutter/material.dart';

import '../model_theme.dart';

class ThemeSwitch extends StatefulWidget {
  final ModelTheme themeNotifier;

  const ThemeSwitch({Key? key, required this.themeNotifier}) : super(key: key);

  @override
  State<ThemeSwitch> createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  late final ModelTheme _themeNotifier = widget.themeNotifier;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _themeNotifier.isDark,
      // activeColor: Colors.white,
      onChanged: (bool value) {
        _themeNotifier.isDark = value;
      },
    );
  }
}
