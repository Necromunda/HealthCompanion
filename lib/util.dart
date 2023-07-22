import 'package:health_companion/models/fineli_model.dart';
import 'package:health_companion/services/fineli_service.dart';
import 'package:flutter/material.dart';

import 'models/component_model.dart';

class Util {
  static Future<List<Component>?> createComponents(String food) async {
    final data = await FineliService.getFoodItem(food);
    return data?.map((element) => FineliModel.fromJson(element).toComponent()).toList();
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

  static Future<void> showNotification({required BuildContext context, String? title, String? message}) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: title == null ? null : Text(
          title,
          textAlign: TextAlign.center,
        ),
        content: message == null ? null : Text(
          message,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
