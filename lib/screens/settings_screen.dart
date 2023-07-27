import 'package:flutter/material.dart';

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
                  onTap: () {},
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
