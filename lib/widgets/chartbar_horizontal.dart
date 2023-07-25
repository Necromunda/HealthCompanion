import 'package:flutter/material.dart';

class ChartBarHorizontal extends StatelessWidget {
  final String label;
  final double value;
  final double totalValuePct;

  const ChartBarHorizontal(
      {Key? key,
      required this.label,
      required this.value,
      required this.totalValuePct})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Column(
        children: <Widget>[
          // SizedBox(
          //   height: 18,
          //   child: FittedBox(
          //     child: Text("${value.toStringAsFixed(0)} $label"),
          //   ),
          // ),
          // const SizedBox(
          //   height: 5,
          // ),
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
                    widthFactor: totalValuePct,
                    child: Container(
                      decoration: BoxDecoration(
                        color: totalValuePct == 1.0
                            ? Colors.green
                            : Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                Align(
                  child: SizedBox(
                    height: 18,
                    child: FittedBox(
                      child: Text("${value.toStringAsFixed(0)} $label"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(
          //   // height: constraints.maxHeight * 0.05,
          //   height: 5,
          // ),
          // SizedBox(
          //   height: 18,
          //   child: FittedBox(
          //     child: Text("${value.toStringAsFixed(0)} $label"),
          //   ),
          // ),
          // SizedBox(
          //   // height: constraints.maxHeight * 0.15,
          //   height: 15,
          //   child: FittedBox(
          //     child: Text(label),
          //   ),
          // ),
        ],
      ),
    );
    // },
    // );
  }
}
