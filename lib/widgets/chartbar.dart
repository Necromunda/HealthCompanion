import 'package:flutter/material.dart';

import '../util.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double value;
  final int goal;

  const ChartBar({
    Key? key,
    required this.label,
    required this.value,
    required this.goal,
  }) : super(key: key);

  double get totalValuePct {
    double pct = value.ceil() / goal;
    return pct;
  }

  Color chartColor(context) {
    ThemeData theme = Theme.of(context);

    if (isGoalZero || totalValuePct < 1.0) {
      // return theme.colorScheme.onPrimary;
      return Util.isDark(context)
          ? theme.colorScheme.onPrimary
          : theme.colorScheme.primary;
    } else if (totalValuePct == 1.0) {
      return Colors.green;
    } else {
      return Colors.redAccent;
    }
  }

  bool get isGoalZero => goal == 0 ? true : false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.5),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 18,
            child: FittedBox(
              child: isGoalZero
                  ? Text("${value.ceil()}g")
                  : Text("$goal\g / ${value.ceil()}g"),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 75,
            width: 10,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    color: const Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: totalValuePct <= 1.0 ? totalValuePct : 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: chartColor(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 18,
            child: FittedBox(
              child: Text(label),
            ),
          ),
        ],
      ),
    );
  }
}
