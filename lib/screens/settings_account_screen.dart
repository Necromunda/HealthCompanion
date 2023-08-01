import 'package:flutter/material.dart';
import 'package:health_companion/screens/settings_change_account_details_screen.dart';
import 'package:health_companion/screens/settings_change_preferences_screen.dart';

class SettingsAccount extends StatefulWidget {
  const SettingsAccount({Key? key}) : super(key: key);

  @override
  State<SettingsAccount> createState() => _SettingsAccountState();
}

class _SettingsAccountState extends State<SettingsAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: const Text("Preferences"),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EditPreferences(),
                  ),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: const Text("Account details"),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ChangeAccountDetails(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
