import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../util.dart';

class ChartBarHorizontal extends StatelessWidget {
  final String label;
  final double value;
  final int goal;

  const ChartBarHorizontal({
    Key? key,
    required this.label,
    required this.value,
    required this.goal,
  }) : super(key: key);

  double get totalValuePct {
    double pct = value.ceil() / goal;
    return pct;
    // return pct > 1.0 ? 1.0 : pct;
  }

  double get widthFactor {
    return totalValuePct > 1.0 ? 1.0 : totalValuePct;
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
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
            width: MediaQuery.of(context).size.width * 0.8,
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
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    // heightFactor: totalValuePct,
                    widthFactor: widthFactor,
                    child: Container(
                      decoration: BoxDecoration(
                        color: chartColor(context),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                Align(
                  child: SizedBox(
                    height: 18,
                    child: FittedBox(
                      child: isGoalZero
                          ? Text("${value.ceil()} $label")
                          : Text(
                              "$goal $label / ${value.ceil()} $label",
                              style: TextStyle(
                                color: Colors.black
                                  // color: Util.isDark(context)
                                  //     ? Colors.white
                                  //     : Colors.black
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
