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
  final MaterialStateProperty<Icon?> thumbIcon =
  MaterialStateProperty.resolveWith<Icon?>(
        (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.nightlight);
      }
      return const Icon(Icons.sunny);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _themeNotifier.isDark,
      thumbIcon: thumbIcon,
      onChanged: (bool value) {
        print("Switch $value");
        _themeNotifier.isDark = value;
      },
    );
  }
}
