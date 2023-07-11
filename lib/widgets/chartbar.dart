import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double value;
  final double totalValuePct;

  const ChartBar(
      {Key? key,
      required this.label,
      required this.value,
      required this.totalValuePct})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return LayoutBuilder(
    //   builder: (ctx, constraints) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.5),
      child: Column(
        children: <Widget>[
          SizedBox(
            // height: constraints.maxHeight * 0.15,
            height: 18,
            child: FittedBox(
              child: Text("${value.toStringAsFixed(0)}g"),
            ),
          ),
          // SizedBox(
          //   // height: constraints.maxHeight * 0.15,
          //   height: 18,
          //   child: FittedBox(
          //     child: Text("${(totalValuePct * 100).toStringAsFixed(0)}%"),
          //   ),
          // ),
          const SizedBox(
            // height: constraints.maxHeight * 0.05,
            height: 5,
          ),
          SizedBox(
            // height: constraints.maxHeight * 0.6,
            height: 75,
            width: 10,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    color: const Color.fromRGBO(220, 220, 220, 1),
                    // color: totalValuePct == 1.0
                    //     ? Colors.green
                    //     : Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: totalValuePct,
                    child: Container(
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.grey, width: 1.0),
                        // color: const Color.fromRGBO(220, 220, 220, 1),
                        color: totalValuePct == 1.0
                            ? Colors.green
                            : Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            // height: constraints.maxHeight * 0.05,
            height: 5,
          ),
          SizedBox(
            // height: constraints.maxHeight * 0.15,
            height: 15,
            child: FittedBox(
              child: Text(label),
            ),
          ),
        ],
      ),
    );
    // },
    // );
  }

// @override
// Widget build(BuildContext context) {
//   return Column(
//     children: [
//       Row(
//         children: [
//           Stack(
//             children: [
//               Container(
//                 height: 75,
//                 width: 10,
//                 color: Colors.grey,
//               ),
//               Container(
//                 height: 50,
//                 width: 10,
//                 color: Colors.blue,
//               ),
//             ],
//           )
//         ],
//       ),
//       Text(value.toString()),
//       Text(title),
//     ],
//   );
// }
}
