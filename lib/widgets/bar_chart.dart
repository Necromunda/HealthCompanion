import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:health_companion/models/bundle_model.dart';
import 'package:health_companion/models/user_preferences_model.dart';

import '../util.dart';

class BarChart extends StatefulWidget {
  final Bundle bundle;
  final UserPreferences userPreferences;

  const BarChart(
      {Key? key, required this.bundle, required this.userPreferences})
      : super(key: key);

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  late final Bundle _bundle;
  late final UserPreferences _userPreferences;
  late final List<_ChartData> data;
  late final List<String> _labels;
  late final List<double> _values;
  late final List<int?> _limits;

  @override
  void initState() {
    _bundle = widget.bundle;
    _userPreferences = widget.userPreferences;
    data = <_ChartData>[];
    _labels = [
      'energykj',
      'energykcal',
    ];
    _values = [
      _bundle.totalEnergy!,
      _bundle.totalEnergyKcal!,
    ];
    _limits = [
      _userPreferences.energyKj == 0 ? null : _userPreferences.energyKj,
      _userPreferences.energyKcal == 0 ? null : _userPreferences.energyKcal,
    ];
    for (var pairs in IterableZip([_labels, _values, _limits])) {
      data.add(
          _ChartData(pairs[0] as String, pairs[1] as double, pairs[2] as int?));
    }
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
            // labelIntersectAction: AxisLabelIntersectAction.rotate45,
            // labelsExtent: 60,
            ),
        primaryYAxis: NumericAxis(
          minimum: 0,
          interval: 500,
          // maximum: _userPreferences.energyKcal == 0
          //     ? null
          //     : _userPreferences.energyKcal.toDouble(),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        // enableSideBySideSeriesPlacement: false,
        series: <ChartSeries<_ChartData, String>>[
          BarSeries<_ChartData, String>(
            width: 0.9,
            dataSource: data,
            xValueMapper: (_ChartData data, _) =>
                AppLocalizations.of(context)!.macro(data.x),
            yValueMapper: (_ChartData data, _) => data.y,
            name: AppLocalizations.of(context)!.macro('title'),
            color: Util.getPrimaryColor(context),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              // labelAlignment: ChartDataLabelAlignment.,
            ),
          ), // RangeAreaSeries<_ChartData, String>(
          //   dataSource: data,
          //   // width: 0.9,
          //   xValueMapper: (_ChartData data, _) =>
          //       AppLocalizations.of(context)!.macro(data.x),
          //   lowValueMapper: (_ChartData data, _) => data.y,
          //   highValueMapper: (_ChartData data, _) => data.yLimit,
          //   name: AppLocalizations.of(context)!.limit,
          //   pointColorMapper: (_ChartData data, _) {
          //     if (data.yLimit == null) {
          //       return Util.getPrimaryColor(context);
          //     } else {
          //       return data.y <= data.yLimit! ? Colors.green : Colors.red;
          //     }
          //   },
          //   dataLabelSettings: const DataLabelSettings(
          //     isVisible: true,
          //     // labelAlignment: ChartDataLabelAlignment.top,
          //   ),
          // )
          // ,
        ],
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.yLimit);

  final String x;
  final double y;
  final int? yLimit;
}
