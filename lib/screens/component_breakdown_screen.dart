import 'package:flutter/material.dart';

import '../models/component_model.dart';

class ComponentBreakdown extends StatefulWidget {
  final Component component;

  const ComponentBreakdown({Key? key, required this.component}) : super(key: key);

  @override
  State<ComponentBreakdown> createState() => _ComponentBreakdownState();
}

class _ComponentBreakdownState extends State<ComponentBreakdown> {
  late final ScrollController _scrollController, _listScrollController;
  late final Component _component;
  static const List<String> _labels = [
    "EnergyKJ",
    "EnergyKcal",
    "Alcohol",
    "Carbohydrates",
    "Fat",
    "Fiber",
    "Organic acids",
    "Protein",
    "Salt",
    "Saturated fat",
    "Sugar",
    "Sugar alcohol"
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        // child: SingleChildScrollView(
        //   controller: _scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _component.name!,
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                if (_component.description!.isNotEmpty)
                  Text(
                    _component.description!,
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                Text(
                  _component.category!,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
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
                  "Macros (${_component.macroSelection!.toLowerCase()})",
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
                                e,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            if (_component.subComponents == null || _component.subComponents!.isEmpty)
              const Expanded(
                child: SizedBox(
                  child: Center(
                    child: Text(
                      "No sub components",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              )
            // if (_component.subComponents!.isNotEmpty)
            else
              Card(
                // width: double.infinity,
                // height: double.infinity,
                child: ListView.builder(
                  controller: _listScrollController,
                  itemCount: _component.subComponents!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        _component.subComponents![index].name!,
                        style: const TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        _component.subComponents![index].description!,
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: const Icon(Icons.launch),
                      onTap: () => _showComponentBreakdown(_component.subComponents![index]),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      // ),
    );
  }
}
