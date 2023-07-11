import 'package:flutter/material.dart';
import 'package:health_companion/widgets/chartbar.dart';
import 'package:health_companion/widgets/chartbar_horizontal.dart';
import 'package:intl/intl.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Column(
                  children: [
                    Text(
                      DateFormat('d.M').format(
                        DateTime.now(),
                      ),
                      style: const TextStyle(fontSize: 24),
                    ),
                    Text(
                      DateFormat('EEEE').format(
                        DateTime.now(),
                      ),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const ChartBar(
                            label: "Carbs",
                            value: 75,
                            totalValuePct: 75 / 300,
                          ),
                          const ChartBar(
                            label: "Fat",
                            value: 35,
                            totalValuePct: 35 / 80,
                          ),
                          const ChartBar(
                            label: "Fat, sat.",
                            value: 15,
                            totalValuePct: 15 / 25,
                          ),
                          const ChartBar(
                            label: "Fiber",
                            value: 15,
                            totalValuePct: 15 / 35,
                          ),
                          const ChartBar(
                            label: "Protein",
                            value: 77,
                            totalValuePct: 77 / 136.5,
                          ),
                          const ChartBar(
                            label: "Salt",
                            value: 7,
                            totalValuePct: 7 / 10,
                          ),
                          const ChartBar(
                            label: "Sugar",
                            value: 10,
                            totalValuePct: 10 / 50,
                          ),
                        ],
                      ),
                      ChartBarHorizontal(label: "Energy (kcal)", value: 750, totalValuePct: 850 / 1500)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
