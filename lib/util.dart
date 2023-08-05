import 'package:flutter/cupertino.dart';
import 'package:health_companion/models/fineli_model.dart';
import 'package:health_companion/models/user_achievement_model.dart';
import 'package:health_companion/services/fineli_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/component_model.dart';

class Util {
  static bool isDark(context) =>
      Theme.of(context).brightness == Brightness.dark;

  static bool isNextDay({required DateTime now, required DateTime compareTo}) {
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
            child: const Text('Ok'),
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

  static bool userHasAchievement(
      List<UserAchievement> achievements, String name) {
    for (final element in achievements) {
      if (element.name == name) {
        return true;
      }
    }
    return false;
  }

  static Future<void> showAchievementNotification(
      context, String title, String imagePath) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Text(
                'New achievement unlocked!',
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                DateFormat('d.M.yyyy H:mm').format(DateTime.now()),
                style:
                    const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: Image.asset(
                  imagePath,
                  width: 200,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
