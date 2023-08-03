import 'package:health_companion/models/fineli_model.dart';
import 'package:health_companion/models/user_achievements_model.dart';
import 'package:health_companion/services/fineli_service.dart';
import 'package:flutter/material.dart';

import 'models/component_model.dart';

class Util {
  static bool isDark(context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Future<List<Component>?> createComponents(String food) async {
    final data = await FineliService.getFoodItem(food);
    return data
        ?.map((element) => FineliModel.fromJson(element).toComponent())
        .toList();
  }

  static bool isNextDay({required DateTime now, required DateTime compareTo}) {
    // Convert both DateTime objects to have the same time (00:00:00) to compare the date only
    // DateTime date1 = DateTime(now.year, now.month, now.day);
    // DateTime date2 = DateTime(compareTo.year, compareTo.month, compareTo.day);

    // Calculate the difference in days between the two dates
    Duration difference = now.difference(compareTo);

    // If the difference is exactly one day, then it's the next day
    return difference.inDays >= 1;
  }

  static Future<void> showNotification(
      {required BuildContext context, String? title, String? message}) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: title == null
            ? null
            : Text(
                title,
                // textAlign: TextAlign.center,
              ),
        content: message == null
            ? null
            : Text(
                message,
                // textAlign: TextAlign.center,
              ),
        contentPadding:
            const EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 0),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }

  static void showSnackBar(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);

    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  static bool userHasAchievement(List<UserAchievement> achievements, String name) {
    return achievements.map((e) => e.name == name).toList().isNotEmpty;
  }

//   static Future<void> showDialog(BuildContext context, String title, String message) {
//     return showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           title,
//           textAlign: TextAlign.center,
//         ),
//         content: Text(
//           message,
//           textAlign: TextAlign.center,
//         ),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text("Dismiss"),
//           ),
//         ],
//       ),
//     );
//   }
}
