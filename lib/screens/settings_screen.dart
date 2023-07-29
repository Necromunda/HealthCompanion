import 'package:flutter/material.dart';
import 'package:health_companion/screens/settings_general_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  title: const Text("Account"),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () {},
                ),
                const Divider(
                  height: 0,
                  indent: 10,
                  endIndent: 10,
                  color: Colors.black,
                ),
                ListTile(
                  title: const Text("General"),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsGeneral(),
                    ),
                  ),
                ),
                // const Divider(
                //   indent: 10,
                //   endIndent: 10,
                //   color: Colors.black,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
