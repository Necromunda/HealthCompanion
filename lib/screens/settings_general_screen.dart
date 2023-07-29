import 'package:flutter/material.dart';
import 'package:health_companion/widgets/theme_switch.dart';
import 'package:provider/provider.dart';

import '../model_theme.dart';

class SettingsGeneral extends StatefulWidget {
  const SettingsGeneral({Key? key}) : super(key: key);

  @override
  State<SettingsGeneral> createState() => _SettingsGeneralState();
}

class _SettingsGeneralState extends State<SettingsGeneral> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
      builder: (context, ModelTheme themeNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(themeNotifier.isDark ? "Dark Mode" : "Light Mode"),
            actions: [
              IconButton(
                icon: Icon(
                  themeNotifier.isDark
                      ? Icons.nightlight_round
                      : Icons.wb_sunny,
                ),
                onPressed: () {
                  themeNotifier.isDark
                      ? themeNotifier.isDark = false
                      : themeNotifier.isDark = true;
                },
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                title: const Text("Change themes"),
                subtitle: Text(
                    "${themeNotifier.isDark ? "Dark mode" : "Light mode"} is currently active"),
                // trailing: const Icon(Icons.keyboard_arrow_right),
                trailing: ThemeSwitch(
                  themeNotifier: themeNotifier,
                ),
                onTap: null,
              ),
              // ),
            ),
          ),
        );
      },
    );
  }
}
