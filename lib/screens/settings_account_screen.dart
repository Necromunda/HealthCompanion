import 'package:flutter/material.dart';
import 'package:health_companion/screens/settings_change_account_details_screen.dart';
import 'package:health_companion/screens/settings_change_preferences_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.macroLimits),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const EditPreferences(),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 0,
                    indent: 10,
                    endIndent: 10,
                    color: Colors.black,
                  ),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.accountDetails),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ChangeAccountDetails(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
