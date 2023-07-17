import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_companion/screens/add_ingredient_to_component_screen.dart';
import 'package:intl/intl.dart';

import '../models/component_model.dart';
import '../util.dart';

enum Macros { individual, inherit, both }

class AddComponent extends StatefulWidget {
  final List<Component> userComponents;

  const AddComponent({Key? key, required this.userComponents}) : super(key: key);

  @override
  State<AddComponent> createState() => _AddComponentState();
}

class _AddComponentState extends State<AddComponent> {
  static final RegExp _noLeadingZeroRegex = RegExp(r'^(?!0)\d+$');
  static const List<String> _categories = ["Component", "Breakfast", "Lunch", "Dinner", "Snack"];
  static const double _kJMultiplier = 4.1855;
  late final ScrollController _listScrollController;
  late final TextEditingController _nameController,
      _energyKcalController,
      _saltController,
      _proteinController,
      _carbohydrateController,
      _alcoholController,
      _sugarAlcoholController,
      _organicAcidsController,
      _saturatedFatController,
      _fiberController,
      _sugarController,
      _fatController;
  Macros? _macrosSelection;
  String? _name, _category;
  List<Component>? _subComponents;
  late final _userComponents;
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
    _userComponents = widget.userComponents;
    _listScrollController = ScrollController();
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
    _listScrollController.dispose();
    _nameController.dispose();
    _energyKcalController.dispose();
    _saltController.dispose();
    _proteinController.dispose();
    _carbohydrateController.dispose();
    _alcoholController.dispose();
    _sugarAlcoholController.dispose();
    _organicAcidsController.dispose();
    _saturatedFatController.dispose();
    _fiberController.dispose();
    _sugarController.dispose();
    _fatController.dispose();
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
    final data = {};
    return Component();
  }

  void _addIngredientHandler() async {
    // final data = await Util.createComponents("omena");
    // setState(() {
    //   _subComponents = data;
    // });
    List<Component>? chosenComponents = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddIngredient(userComponents: _userComponents),
    ));
    setState(() {
      _subComponents = chosenComponents;
    });
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0),
                child: Card(
                  child: TextField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    onChanged: (value) => setState(() {
                      _name = value;
                    }),
                    decoration: InputDecoration(
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
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
                        color: Theme.of(context).primaryColor,
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
                      (e) => ListTile(
                        title: Text(
                          e,
                          style: TextStyle(
                              fontSize: 18,
                              color: _category == e ? Theme.of(context).primaryColor : null),
                        ),
                        trailing: Icon(
                          Icons.category,
                          color: _category == e ? Theme.of(context).primaryColor : null,
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
                    "Macro type",
                    style: TextStyle(fontSize: 22),
                  ),
                  children: [
                    ListTile(
                      title: Text(
                        "Set individual",
                        style: TextStyle(
                            fontSize: 18,
                            color: _macrosSelection == Macros.individual
                                ? Theme.of(context).primaryColor
                                : null),
                      ),
                      trailing: Icon(
                        Icons.category,
                        color: _macrosSelection == Macros.individual
                            ? Theme.of(context).primaryColor
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
                                ? Theme.of(context).primaryColor
                                : null),
                      ),
                      trailing: Icon(
                        Icons.category,
                        color: _macrosSelection == Macros.inherit
                            ? Theme.of(context).primaryColor
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
                                ? Theme.of(context).primaryColor
                                : null),
                      ),
                      trailing: Icon(
                        Icons.category,
                        color:
                            _macrosSelection == Macros.both ? Theme.of(context).primaryColor : null,
                      ),
                      onTap: () => _macrosDropdownHandler(Macros.both),
                    ),
                  ],
                ),
              ),
              if (_macrosSelection != null && _macrosSelection != Macros.inherit)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      children: [
                        const Text(
                          "Macros",
                          style: TextStyle(fontSize: 22),
                        ),
                        TextField(
                          controller: _energyKcalController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.allow(_noLeadingZeroRegex)
                          ],
                          onChanged: (value) => setState(() {
                            _energyKcal = double.tryParse(value);
                          }),
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
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
                              color: Theme.of(context).primaryColor,
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
                        const SizedBox(height: 10.0),
                        TextField(
                          controller: _proteinController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.allow(_noLeadingZeroRegex)
                          ],
                          onChanged: (value) => setState(() {
                            _protein = double.tryParse(value);
                          }),
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
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
                              color: Theme.of(context).primaryColor,
                            ),
                            hintText: "Protein",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                width: 2.0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextField(
                          controller: _carbohydrateController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.allow(_noLeadingZeroRegex)
                          ],
                          onChanged: (value) => setState(() {
                            _carbohydrate = double.tryParse(value);
                          }),
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
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
                              color: Theme.of(context).primaryColor,
                            ),
                            hintText: "Carbohydrates",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                width: 2.0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextField(
                          controller: _saltController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.allow(_noLeadingZeroRegex)
                          ],
                          onChanged: (value) => setState(() {
                            _salt = double.tryParse(value);
                          }),
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
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
                              color: Theme.of(context).primaryColor,
                            ),
                            hintText: "Salt",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                width: 2.0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextField(
                          controller: _sugarController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.allow(_noLeadingZeroRegex)
                          ],
                          onChanged: (value) => setState(() {
                            _sugar = double.tryParse(value);
                          }),
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
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
                              color: Theme.of(context).primaryColor,
                            ),
                            hintText: "Sugar",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                width: 2.0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextField(
                          controller: _fatController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.allow(_noLeadingZeroRegex)
                          ],
                          onChanged: (value) => setState(() {
                            _fat = double.tryParse(value);
                          }),
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
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
                              color: Theme.of(context).primaryColor,
                            ),
                            hintText: "Fat",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                width: 2.0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextField(
                          controller: _saturatedFatController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.allow(_noLeadingZeroRegex)
                          ],
                          onChanged: (value) => setState(() {
                            _saturatedFat = double.tryParse(value);
                          }),
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
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
                              color: Theme.of(context).primaryColor,
                            ),
                            hintText: "Saturated fat",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                width: 2.0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextField(
                          controller: _fiberController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.allow(_noLeadingZeroRegex)
                          ],
                          onChanged: (value) => setState(() {
                            _fiber = double.tryParse(value);
                          }),
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
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
                              color: Theme.of(context).primaryColor,
                            ),
                            hintText: "Fiber",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                width: 2.0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextField(
                          controller: _organicAcidsController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.allow(_noLeadingZeroRegex)
                          ],
                          onChanged: (value) => setState(() {
                            _organicAcids = double.tryParse(value);
                          }),
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
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
                              color: Theme.of(context).primaryColor,
                            ),
                            hintText: "Organic acids",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                width: 2.0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextField(
                          controller: _alcoholController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.allow(_noLeadingZeroRegex)
                          ],
                          onChanged: (value) => setState(() {
                            _alcohol = double.tryParse(value);
                          }),
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
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
                              color: Theme.of(context).primaryColor,
                            ),
                            hintText: "Alcohol",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                width: 2.0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextField(
                          controller: _sugarAlcoholController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.allow(_noLeadingZeroRegex)
                          ],
                          onChanged: (value) => setState(() {
                            _sugarAlcohol = double.tryParse(value);
                          }),
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
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
                              color: Theme.of(context).primaryColor,
                            ),
                            hintText: "Sugar alcohol",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                width: 2.0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ListTile(
                title: const Text(
                  "Add ingredient +",
                  style: TextStyle(fontSize: 18),
                  // textAlign: TextAlign.center,
                ),
                // trailing: const Icon(Icons.launch),
                onTap: _addIngredientHandler,
              ),
              if (_subComponents != null && _subComponents!.isNotEmpty)
                ListView.builder(
                  controller: _listScrollController,
                  itemCount: _subComponents!.length,
                  // itemCount: 11,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        _subComponents![index].name!,
                        style: const TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        _subComponents![index].description!,
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: const Icon(Icons.launch),
                      onTap: null,
                    );
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}
