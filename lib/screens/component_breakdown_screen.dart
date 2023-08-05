import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/component_model.dart';

class ComponentBreakdown extends StatefulWidget {
  final Component component;

  const ComponentBreakdown({Key? key, required this.component})
      : super(key: key);

  @override
  State<ComponentBreakdown> createState() => _ComponentBreakdownState();
}

class _ComponentBreakdownState extends State<ComponentBreakdown> {
  late final ScrollController _scrollController, _listScrollController;
  late final Component _component;

  // static const List<String> _labels = [
  //   "EnergyKJ",
  //   "EnergyKcal",
  //   "Alcohol",
  //   "Carbohydrates",
  //   "Fat",
  //   "Fiber",
  //   "Organic acids",
  //   "Protein",
  //   "Salt",
  //   "Saturated fat",
  //   "Sugar",
  //   "Sugar alcohol"
  // ];
  static const List<String> _labels = [
    'energykj',
    'energykcal',
    'alcohol',
    'carbohydrate',
    'fat',
    'fiber',
    'organicacids',
    'protein',
    'salt',
    'saturatedfat',
    'sugar',
    'sugaralcohol'
  ];

  @override
  void initState() {
    _component = widget.component;
    _scrollController = ScrollController();
    _listScrollController = ScrollController();
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
    _scrollController.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  void _showComponentBreakdown(Component component) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ComponentBreakdown(
            component: component,
          );
        },
      ),
    );
  }

  String _getBreakdownTitle(String value) {
    print(value);
    if (value == 'ingredients excluded') {
      return "${AppLocalizations.of(context)!.breakdownMacroTitle('individual')} / ${_component.portion?.toStringAsFixed(0)} g";
    } else if (value == 'ingredients included') {
      return "${AppLocalizations.of(context)!.breakdownMacroTitle('inherit')} / ${_component.portion?.toStringAsFixed(0)} g";
    } else {
      return "${AppLocalizations.of(context)!.breakdownMacroTitle('both')} / ${_component.portion?.toStringAsFixed(0)} g";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.hintTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _component.name!,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                    // textAlign: TextAlign.center,
                  ),
                  Text(
                    AppLocalizations.of(context)!.hintDescription,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _component.description!.isNotEmpty
                        ? _component.description!
                        : AppLocalizations.of(context)!.noDescription,
                    style: const TextStyle(fontSize: 18),
                    // textAlign: TextAlign.center,
                  ),
                  Text(
                    AppLocalizations.of(context)!.categories('title'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.categories(
                      _component.category!.toLowerCase(),
                    ),
                    // _component.category!,
                    style: const TextStyle(fontSize: 18),
                    // textAlign: TextAlign.center,
                  ),
                  Text(
                    AppLocalizations.of(context)!.created,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('d.M H:mm').format(_component.creationDate!),
                    style: const TextStyle(fontSize: 18),
                    // textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getBreakdownTitle(
                      _component.macroSelection!.toLowerCase(),
                    ),
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._labels.map((e) {
                            return Column(
                              children: [
                                Text(
                                  // e,
                                  AppLocalizations.of(context)!.macro(e),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                      const SizedBox(
                        width: 50.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${_component.energy?.toStringAsFixed(0)} kJ",
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "${_component.energyKcal?.toStringAsFixed(0)} kcal",
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "${_component.alcohol?.toStringAsFixed(0)} g",
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "${_component.carbohydrate?.toStringAsFixed(0)} g",
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "${_component.fat?.toStringAsFixed(0)} g",
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "${_component.fiber?.toStringAsFixed(0)} g",
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "${_component.organicAcids?.toStringAsFixed(0)} g",
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "${_component.protein?.toStringAsFixed(0)} g",
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "${_component.salt?.toStringAsFixed(0)} g",
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "${_component.saturatedFat?.toStringAsFixed(0)} g",
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "${_component.sugar?.toStringAsFixed(0)} g",
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "${_component.sugarAlcohol?.toStringAsFixed(0)} g",
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 25.0,
              ),
              if (_component.subComponents == null ||
                  _component.subComponents!.isEmpty)
                SizedBox(
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.noIngredients,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 332,
                  child: ListView.builder(
                    controller: _listScrollController,
                    itemCount: _component.subComponents!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(
                            _component.subComponents![index].name!,
                            style: const TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                            _component.subComponents![index].description!,
                            style: const TextStyle(fontSize: 16),
                          ),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                          onTap: () => _showComponentBreakdown(
                            _component.subComponents![index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
