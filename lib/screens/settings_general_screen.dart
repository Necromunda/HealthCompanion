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
            title: Text(AppLocalizations.of(context)!.generalTitle),
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
                    title: const Text("Change themes"),
                    subtitle: Text(
                      "${themeNotifier.isDark ? "Dark mode" : "Light mode"} is currently active",
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
                    title: Text("Change languages"),
                    subtitle: Text('Current language is'),
                    children: [
                      ListTile(
                        title: Text('English'),
                        selected: themeNotifier.locale == 'en' ? true : false,
                        onTap: () => themeNotifier.locale = 'en',
                      ),
                      ListTile(
                        title: Text('Finnish'),
                        selected: themeNotifier.locale == 'fi' ? true : false,
                        onTap: () => themeNotifier.locale = 'fi',
                      ),
                      // ListTile(),
                    ],
                  ),
                  // const Divider(
                  //   indent: 10,
                  //   endIndent: 10,
                  //   color: Colors.black,
                  // ),
                ],
              ),
            ),

            // Column(
            //   children: [
            //     Card(
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10)),
            //       child: ListTile(
            //         title: const Text("Change themes"),
            //         subtitle: Text(
            //           "${themeNotifier.isDark ? "Dark mode" : "Light mode"} is currently active",
            //         ),
            //         // trailing: const Icon(Icons.keyboard_arrow_right),
            //         trailing: ThemeSwitch(
            //           themeNotifier: themeNotifier,
            //         ),
            //         onTap: null,
            //       ),
            //       // ),
            //     ),
            //     // _descriptionTextField,
            //   ],
            // ),
          ),
        );
      },
    );
  }

// Widget get _descriptionTextField => TextField(
//       onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
//       // controller: _descriptionController,
//       keyboardType: TextInputType.text,
//       maxLength: 50,
//       onChanged: (value) {
//         setState(() {
//           // _description = value;
//         });
//       },
//       style: TextStyle(
//           color: Util.isDark(context) ? Colors.black : Colors.white),
//       decoration: InputDecoration(
//         counterText: "",
//         hintText: "Description",
//         contentPadding: const EdgeInsets.only(right: 10),
//         filled: true,
//         // fillColor: const Color(0XDEDEDEDE),
//         fillColor: Theme.of(context).colorScheme.secondaryContainer,
//         focusedBorder: const OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.transparent,
//             width: 2.0,
//           ),
//         ),
//         enabledBorder: const OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.transparent,
//             width: 2.0,
//           ),
//         ),
//         prefixIcon: Container(
//           margin: const EdgeInsets.only(right: 15.0),
//           decoration: BoxDecoration(
//             color: _descriptionController.text.isEmpty
//                 ? null
//                 : Colors.lightGreen,
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(5.0),
//               bottomLeft: Radius.circular(5.0),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(1),
//                 spreadRadius: -1,
//                 offset: const Offset(2, 0), // changes position of shadow
//               ),
//               BoxShadow(
//                 // color: const Color(0XDEDEDEDE).withOpacity(1),
//                 // color: const Color(0x00E7E0EC).withOpacity(1),
//                 color: Theme.of(context).colorScheme.secondaryContainer,
//                 spreadRadius: 0,
//                 offset: const Offset(1, 0), // changes position of shadow
//               ),
//             ],
//           ),
//           child: const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20),
//             child: Icon(
//               Icons.description,
//               size: 30,
//             ),
//           ),
//         ),
//       ),
//     );
}
