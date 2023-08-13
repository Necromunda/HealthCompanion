import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


import '../models/bundle_model.dart';
import '../models/user_preferences_model.dart';

class CircularChart extends StatefulWidget {
  final Bundle bundle;
  final UserPreferences userPreferences;

  const CircularChart({Key? key, required this.bundle, required this.userPreferences}) : super(key: key);

  @override
  State<CircularChart> createState() => _CircularChartState();
}

class _CircularChartState extends State<CircularChart> {
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
      'alcohol',
      'carbohydrate',
      'fat',
      'fiber',
      'organicacids',
      'protein',
      'salt',
      'saturatedfat',
      'sugar',
      'sugaralcohol',
    ];
    _values = [
      _bundle.totalAlcohol!,
      _bundle.totalCarbohydrate!,
      _bundle.totalFat!,
      _bundle.totalFiber!,
      _bundle.totalOrganicAcids!,
      _bundle.totalProtein!,
      _bundle.totalSalt!,
      _bundle.totalSaturatedFat!,
      _bundle.totalSugar!,
      _bundle.totalSugarAlcohol!,
    ];
    _limits = [
      _userPreferences.alcohol == 0 ? null : _userPreferences.alcohol,
      _userPreferences.carbohydrate == 0 ? null : _userPreferences.carbohydrate,
      _userPreferences.fat == 0 ? null : _userPreferences.fat,
      _userPreferences.fiber == 0 ? null : _userPreferences.fiber,
      _userPreferences.organicAcids == 0 ? null : _userPreferences.organicAcids,
      _userPreferences.protein == 0 ? null : _userPreferences.protein,
      _userPreferences.salt == 0 ? null : _userPreferences.salt,
      _userPreferences.saturatedFat == 0 ? null : _userPreferences.saturatedFat,
      _userPreferences.sugar == 0 ? null : _userPreferences.sugar,
      _userPreferences.sugarAlcohol == 0 ? null : _userPreferences.sugarAlcohol,
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
      height: 250,
      child: SfCircularChart(
        margin: EdgeInsets.zero,
        //   margin: EdgeInsets.all(15),
        legend: Legend(isVisible: true),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CircularSeries<_ChartData, String>>[
          RadialBarSeries<_ChartData, String>(
            dataSource: data,
            xValueMapper: (_ChartData data, _) =>
                AppLocalizations.of(context)!.macro(data.x),
            yValueMapper: (_ChartData data, _) => data.y,
            // pointRadiusMapper: (_ChartData data, _) => '200%',
            name: AppLocalizations.of(context)!.macro('title'),
              dataLabelSettings: const DataLabelSettings(
                  isVisible: true
              )
          ),
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
