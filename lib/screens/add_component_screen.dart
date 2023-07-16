import 'package:flutter/material.dart';

import '../models/component_model.dart';

enum Macros { individual, inherit, both }

class AddComponent extends StatefulWidget {
  const AddComponent({Key? key}) : super(key: key);

  @override
  State<AddComponent> createState() => _AddComponentState();
}

class _AddComponentState extends State<AddComponent> {
  static const List<String> _categories = ["Component", "Breakfast", "Lunch", "Dinner", "Snack"];
  static const double _kJMultiplier = 4.1855;
  late final TextEditingController _nameController, _energyKcalController, _saltController,
      _proteinController, _carbohydrateController, _alcoholController, _sugarAlcoholController,
      _organicAcidsController, _saturatedFatController, _fiberController, _sugarController,
      _fatController;
  Macros? _macrosSelection;
  String? _name, _category;
  List<Component>? _subComponents;
  double? _salt,
      _energy,
      _energyKcal,
      _protein,
      _carbohydrate,
      _alcohol,
      _organicAcids,
      _sugarAlcohol,
      _saturatedFat,
      _fiber,
      _sugar,
      _fat;

  @override
  void initState() {
    _nameController = TextEditingController();
    _energyKcalController = TextEditingController();
    _saltController = TextEditingController();
    _proteinController = TextEditingController();
    _carbohydrateController = TextEditingController();
    _alcoholController = TextEditingController();
    _sugarAlcoholController = TextEditingController();
    _organicAcidsController = TextEditingController();
    _saturatedFatController = TextEditingController();
    _fiberController = TextEditingController();
    _sugarController = TextEditingController();
    _fatController = TextEditingController();
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
    _nameController.dispose();
    _energyKcalController.dispose();
    super.dispose();
  }

  void _categoryDropdownHandler(String category) {
    setState(() {
      _category = category;
    });
  }

  void _macrosDropdownHandler(Macros macrosSelection) {
    setState(() {
      switch (macrosSelection) {
        case Macros.individual:
          _macrosSelection = Macros.individual;
          break;
        case Macros.inherit:
          _macrosSelection = Macros.inherit;
          break;
        case Macros.both:
          _macrosSelection = Macros.both;
          break;
      }
    });
  }

  Component _createComponent() {
    final data = {
    };
    return Component();
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.check,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(_createComponent()),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: TextField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                onChanged: (value) =>
                    setState(() {
                      _name = value;
                    }),
                decoration: InputDecoration(
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.title,
                    color: Theme
                        .of(context)
                        .primaryColor,
                  ),
                  hintText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(
                      width: 2.0,
                      style: BorderStyle.none,
                    ),
                  ),
                ),
              ),
            ),
            Card(
              elevation: 0,
              child: ExpansionTile(
                title: const Text(
                  "Category",
                  style: TextStyle(fontSize: 22),
                ),
                children: [
                  ..._categories.map(
                        (e) =>
                        ListTile(
                          title: Text(
                            e,
                            style: TextStyle(
                                fontSize: 18,
                                color: _category == e ? Theme
                                    .of(context)
                                    .primaryColor : null),
                          ),
                          trailing: Icon(
                            Icons.category,
                            color: _category == e ? Theme
                                .of(context)
                                .primaryColor : null,
                          ),
                          onTap: () => _categoryDropdownHandler(e),
                        ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 0,
              child: ExpansionTile(
                title: const Text(
                  "Macros",
                  style: TextStyle(fontSize: 22),
                ),
                children: [
                  ListTile(
                    title: Text(
                      "Set individual",
                      style: TextStyle(
                          fontSize: 18,
                          color: _macrosSelection == Macros.individual
                              ? Theme
                              .of(context)
                              .primaryColor
                              : null),
                    ),
                    trailing: Icon(
                      Icons.category,
                      color: _macrosSelection == Macros.individual
                          ? Theme
                          .of(context)
                          .primaryColor
                          : null,
                    ),
                    onTap: () => _macrosDropdownHandler(Macros.individual),
                  ),
                  ListTile(
                    title: Text(
                      "Inherit from child components",
                      style: TextStyle(
                          fontSize: 18,
                          color: _macrosSelection == Macros.inherit
                              ? Theme
                              .of(context)
                              .primaryColor
                              : null),
                    ),
                    trailing: Icon(
                      Icons.category,
                      color: _macrosSelection == Macros.inherit
                          ? Theme
                          .of(context)
                          .primaryColor
                          : null,
                    ),
                    onTap: () => _macrosDropdownHandler(Macros.inherit),
                  ),
                  ListTile(
                    title: Text(
                      "Both",
                      style: TextStyle(
                          fontSize: 18,
                          color: _macrosSelection == Macros.both
                              ? Theme
                              .of(context)
                              .primaryColor
                              : null),
                    ),
                    trailing: Icon(
                      Icons.category,
                      color:
                      _macrosSelection == Macros.both ? Theme
                          .of(context)
                          .primaryColor : null,
                    ),
                    onTap: () => _macrosDropdownHandler(Macros.both),
                  ),
                ],
              ),
            ),
            Card(child: Column(children: [
              TextField(
                controller: _energyKcalController,
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    setState(() {
                      _energyKcal = double.tryParse(value);
                    }),
                decoration: InputDecoration(
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.title,
                    color: Theme
                        .of(context)
                        .primaryColor,
                  ),
                  hintText: "Kcal",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(
                      width: 2.0,
                      style: BorderStyle.none,
                    ),
                  ),
                ),
              ),
            ],),)
          ],
        ),
      ),
    );
  }
}
