import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AchievementTemplate extends StatelessWidget {
  const AchievementTemplate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text("Create 10 components"),
        subtitle: Text("Unlocked ${DateFormat('d.M.yyyy HH:mm').format(DateTime.now())}"),
      ),
    );
  }
}
