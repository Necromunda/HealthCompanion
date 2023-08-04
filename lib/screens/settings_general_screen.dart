import 'package:flutter/material.dart';
import 'package:health_companion/widgets/theme_switch.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model_preferences.dart';
import '../util.dart';

class SettingsGeneral extends StatefulWidget {
  const SettingsGeneral({Key? key}) : super(key: key);

  @override
  State<SettingsGeneral> createState() => _SettingsGeneralState();
}

class _SettingsGeneralState extends State<SettingsGeneral> {
  // TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // print("build");
    // print(Util.isDark(context));
    return Consumer<ModelPreferences>(
      builder: (context, ModelPreferences themeNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
              // color: Colors.black,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.changeTheme),
                    subtitle: Text(
                      themeNotifier.isDark
                          ? AppLocalizations.of(context)!.darkThemeSelected
                          : AppLocalizations.of(context)!.lightThemeSelected,
                    ),
                    // trailing: const Icon(Icons.keyboard_arrow_right),
                    trailing: ThemeSwitch(
                      themeNotifier: themeNotifier,
                    ),
                    onTap: null,
                  ),
                  const Divider(
                    height: 0,
                    indent: 10,
                    endIndent: 10,
                    color: Colors.black,
                  ),
                  ExpansionTile(
                    shape: Border.all(color: Colors.transparent),
                    title: Text(AppLocalizations.of(context)!.changeLocale),
                    subtitle: Text(
                      AppLocalizations.of(context)!
                          .currentLocale(AppLocalizations.of(context)!.locale),
                    ),
                    children: [
                      ListTile(
                        title: Text(
                            AppLocalizations.of(context)!.locales('english')),
                        selected: themeNotifier.locale == 'en' ? true : false,
                        onTap: () => themeNotifier.locale = 'en',
                      ),
                      ListTile(
                        title: Text(
                            AppLocalizations.of(context)!.locales('finnish')),
                        selected: themeNotifier.locale == 'fi' ? true : false,
                        onTap: () => themeNotifier.locale = 'fi',
                      ),
                      // ListTile(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
