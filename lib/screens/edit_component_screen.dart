import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_companion/screens/add_existing_component_screen.dart';

import '../models/component_model.dart';
import '../util.dart';
import 'component_breakdown_screen.dart';

enum Macros { individual, inherit, both }

class EditComponent extends StatefulWidget {
  final Component component;

  const EditComponent({Key? key, required this.component}) : super(key: key);

  @override
  State<EditComponent> createState() => _EditComponentState();
}

class _EditComponentState extends State<EditComponent> {
  final RegExp _macroRegExp = RegExp(r'^[0-9]\d*((\.|,)\d?)?');

  // final RegExp _macroRegExp = RegExp(r"^[0-9][1-9]*((\.|,)\d?)?");
  static final RegExp _noOnlySpacesRegexp = RegExp(r'^\s*$');
  static const double _kJMultiplier = 4.1855;
  late List<String> _categories;

  // late Component _component;
  late Macros _macrosSelection;
  late String _title, _description, _category, _macrosSelectionText;
  late List<Component> _subComponents;
  late final ScrollController _listScrollController;
  late final TextEditingController _titleController,
      _descriptionController,
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
  late double? _salt,
      _energyKj,
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
  late bool _isTitleEmpty;

  @override
  void initState() {
    _listScrollController = ScrollController();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
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

    // _component = Component.fromJson(widget.component.toJson());
    _title = widget.component.name!;
    _isTitleEmpty = isTitleEmpty;
    _description = widget.component.description!;
    _category = widget.component.category!;
    _macrosSelectionText = widget.component.macroSelection!;
    _macrosSelection = _getMacrosSelectionFromString(_macrosSelectionText);
    _subComponents = List.from(widget.component.subComponents!);
    // _subComponents = [];
    _categories = ["Component", "Breakfast", "Lunch", "Dinner", "Snack"];
    if (!_categories.contains(_category)) {
      _categories.insert(0, _category);
    }
    _initMacros(_macrosSelection);
    _initControllers();
    super.initState();
  }

  bool get isTitleEmpty =>
      (_title.isEmpty || _noOnlySpacesRegexp.hasMatch(_title)) ? true : false;

  void _initControllers() {
    _titleController.text = _title;
    _descriptionController.text = _description;
    _energyKcalController.text = _energyKcal!.toStringAsFixed(1);
    _proteinController.text = _protein!.toStringAsFixed(1);
    _carbohydrateController.text = _carbohydrate!.toStringAsFixed(1);
    _saltController.text = _salt!.toStringAsFixed(1);
    _sugarController.text = _sugar!.toStringAsFixed(1);
    _fatController.text = _fat!.toStringAsFixed(1);
    _saturatedFatController.text = _saturatedFat!.toStringAsFixed(1);
    _fiberController.text = _fiber!.toStringAsFixed(1);
    _organicAcidsController.text = _organicAcids!.toStringAsFixed(1);
    _alcoholController.text = _alcohol!.toStringAsFixed(1);
    _sugarAlcoholController.text = _sugarAlcohol!.toStringAsFixed(1);
  }

  void _initMacros(Macros macrosSelection) {
    switch (macrosSelection) {
      case Macros.individual:
        _energyKj = widget.component.energy!;
        _energyKcal = widget.component.energyKcal!;
        _salt = widget.component.salt!;
        _protein = widget.component.protein!;
        _carbohydrate = widget.component.carbohydrate!;
        _alcohol = widget.component.alcohol!;
        _organicAcids = widget.component.organicAcids!;
        _sugarAlcohol = widget.component.sugarAlcohol!;
        _saturatedFat = widget.component.saturatedFat!;
        _fiber = widget.component.fiber!;
        _sugar = widget.component.sugar!;
        _fat = widget.component.fat!;
        break;
      case Macros.inherit:
        _energyKj = 0.0;
        _energyKcal = 0.0;
        _salt = 0.0;
        _protein = 0.0;
        _carbohydrate = 0.0;
        _alcohol = 0.0;
        _organicAcids = 0.0;
        _sugarAlcohol = 0.0;
        _saturatedFat = 0.0;
        _fiber = 0.0;
        _sugar = 0.0;
        _fat = 0.0;
        break;
      case Macros.both:
        _energyKj = widget.component.energy! - _ingredientsTotalEnergy;
        _energyKj = _energyKj!.isNegative ? 0.0 : _energyKj;

        _energyKcal =
            widget.component.energyKcal! - _ingredientsTotalEnergyKcal;
        _energyKcal = _energyKcal!.isNegative ? 0.0 : _energyKcal;

        _salt = widget.component.salt! - _ingredientsTotalSalt;
        _salt = _salt!.isNegative ? 0.0 : _salt;

        _protein = widget.component.protein! - _ingredientsTotalProtein;
        _protein = _protein!.isNegative ? 0.0 : _protein;

        _carbohydrate =
            widget.component.carbohydrate! - _ingredientsTotalCarbohydrate;
        _carbohydrate = _carbohydrate!.isNegative ? 0.0 : _carbohydrate;

        _alcohol = widget.component.alcohol! - _ingredientsTotalAlcohol;
        _alcohol = _alcohol!.isNegative ? 0.0 : _alcohol;

        _organicAcids =
            widget.component.organicAcids! - _ingredientsTotalOrganicAcids;
        _organicAcids = _organicAcids!.isNegative ? 0.0 : _organicAcids;

        _sugarAlcohol =
            widget.component.sugarAlcohol! - _ingredientsTotalSugarAlcohol;
        _sugarAlcohol = _sugarAlcohol!.isNegative ? 0.0 : _sugarAlcohol;

        _saturatedFat =
            widget.component.saturatedFat! - _ingredientsTotalSaturatedFat;
        _saturatedFat = _saturatedFat!.isNegative ? 0.0 : _saturatedFat;

        _fiber = widget.component.fiber! - _ingredientsTotalFiber;
        _fiber = _fiber!.isNegative ? 0.0 : _fiber;

        _sugar = widget.component.sugar! - _ingredientsTotalSugar;
        _sugar = _sugar!.isNegative ? 0.0 : _sugar;

        _fat = widget.component.fat! - _ingredientsTotalFat;
        _fat = _fat!.isNegative ? 0.0 : _fat;
        break;
    }
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
    _titleController.dispose();
    _descriptionController.dispose();
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

  Macros _getMacrosSelectionFromString(String macrosSelection) {
    if (macrosSelection == 'ingredients included') {
      return Macros.inherit;
    } else if (macrosSelection == 'ingredients included + individual') {
      return Macros.both;
    } else {
      return Macros.individual;
    }
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
          _macrosSelectionText = 'ingredients excluded';
          break;
        case Macros.inherit:
          _macrosSelection = Macros.inherit;
          _macrosSelectionText = 'ingredients included';
          break;
        case Macros.both:
          _macrosSelection = Macros.both;
          _macrosSelectionText = 'ingredients included + individual';
          break;
      }
    });
  }

  Component _createComponent() {
    _energyKj =
        double.tryParse((_energyKcal! * _kJMultiplier).toStringAsFixed(0));
    Map<String, dynamic> data = {
      "name": _title,
      "description": _description,
      "category": _category,
      "macroSelection": _macrosSelectionText,
      "creationDate": widget.component.creationDate,
      "subComponents": _subComponents.map((e) => e.toJson()).toList(),
      "salt": _salt,
      "energy": _energyKj,
      "energyKcal": _energyKcal,
      "protein": _protein,
      "carbohydrate": _carbohydrate,
      "alcohol": _alcohol,
      "organicAcids": _organicAcids,
      "sugarAlcohol": _sugarAlcohol,
      "saturatedFat": _saturatedFat,
      "fiber": _fiber,
      "sugar": _sugar,
      "fat": _fat
    };
    if (_macrosSelection != Macros.individual) {
      data["energy"] = _ingredientsTotalEnergy;
      data["energyKcal"] = _ingredientsTotalEnergyKcal;
      data["salt"] = _ingredientsTotalSalt;
      data["protein"] = _ingredientsTotalProtein;
      data["carbohydrate"] = _ingredientsTotalCarbohydrate;
      data["alcohol"] = _ingredientsTotalAlcohol;
      data["organicAcids"] = _ingredientsTotalOrganicAcids;
      data["sugarAlcohol"] = _ingredientsTotalSugarAlcohol;
      data["saturatedFat"] = _ingredientsTotalSaturatedFat;
      data["fiber"] = _ingredientsTotalFiber;
      data["sugar"] = _ingredientsTotalSugar;
      data["fat"] = _ingredientsTotalFat;
      if (_macrosSelection == Macros.both) {
        data["energy"] += _energyKj!;
        data["energyKcal"] += _energyKcal!;
        data["salt"] += _salt!;
        data["protein"] += _protein!;
        data["carbohydrate"] += _carbohydrate!;
        data["alcohol"] += _alcohol!;
        data["organicAcids"] += _organicAcids!;
        data["sugarAlcohol"] += _sugarAlcohol!;
        data["saturatedFat"] += _saturatedFat!;
        data["fiber"] += _fiber!;
        data["sugar"] += _sugar!;
        data["fat"] += _fat!;
      }
    }
    return Component.fromJson(data);
  }

  void _addIngredientHandler() async {
    FocusManager.instance.primaryFocus?.unfocus();
    List<Component>? selected = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddExistingComponent(),
      ),
    );
    setState(() {
      if (selected != null) {
        _subComponents.addAll(selected.cast<Component>());
      }
    });
  }

  void _removeIngredient(Component component) {
    setState(() {
      _subComponents.remove(component);
    });
  }

  void _showComponentBreakdown(Component component) {
    FocusManager.instance.primaryFocus?.unfocus();
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

  double get _ingredientsTotalEnergy =>
      _subComponents.map((e) => e.energy!).fold(0.0, (a, b) => a + b);

  double get _ingredientsTotalEnergyKcal =>
      _subComponents.map((e) => e.energyKcal!).fold(0.0, (a, b) => a + b);

  double get _ingredientsTotalSalt =>
      _subComponents.map((e) => e.salt!).fold(0.0, (a, b) => a + b);

  double get _ingredientsTotalProtein =>
      _subComponents.map((e) => e.protein!).fold(0.0, (a, b) => a + b);

  double get _ingredientsTotalCarbohydrate =>
      _subComponents.map((e) => e.carbohydrate!).fold(0.0, (a, b) => a + b);

  double get _ingredientsTotalAlcohol =>
      _subComponents.map((e) => e.alcohol!).fold(0.0, (a, b) => a + b);

  double get _ingredientsTotalOrganicAcids =>
      _subComponents.map((e) => e.organicAcids!).fold(0.0, (a, b) => a + b);

  double get _ingredientsTotalSugarAlcohol =>
      _subComponents.map((e) => e.sugarAlcohol!).fold(0.0, (a, b) => a + b);

  double get _ingredientsTotalSaturatedFat =>
      _subComponents.map((e) => e.saturatedFat!).fold(0.0, (a, b) => a + b);

  double get _ingredientsTotalFiber =>
      _subComponents.map((e) => e.fiber!).fold(0.0, (a, b) => a + b);

  double get _ingredientsTotalSugar =>
      _subComponents.map((e) => e.sugar!).fold(0.0, (a, b) => a + b);

  double get _ingredientsTotalFat =>
      _subComponents.map((e) => e.fat!).fold(0.0, (a, b) => a + b);

  Color get selectedColor => Util.isDark(context)
      ? Theme.of(context).colorScheme.onTertiary
      : Theme.of(context).colorScheme.tertiary;

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
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.check,
            ),
            onPressed: () async {
              _isTitleEmpty
                  ? Util.showNotification(
                      context: context, message: "Title must not be empty")
                  : Navigator.of(context).pop(_createComponent());
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      _titleTextField,
                      const SizedBox(
                        height: 5.0,
                      ),
                      _descriptionTextField,
                    ],
                  ),
                ),
              ),
              Card(
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ExpansionTile(
                  shape: Border.all(color: Colors.transparent),
                  onExpansionChanged: (value) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  title: const Text(
                    "Category",
                    style: TextStyle(fontSize: 22),
                  ),
                  children: [
                    ..._categories.map(
                      (category) => ListTile(
                        title: Text(
                          category,
                          style: const TextStyle(fontSize: 18),
                        ),
                        trailing: const Icon(Icons.category),
                        selected: _category == category ? true : false,
                        selectedColor: Colors.white,
                        selectedTileColor:
                            _category == category ? selectedColor : null,
                        onTap: () => _categoryDropdownHandler(category),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ExpansionTile(
                  shape: Border.all(color: Colors.transparent),
                  onExpansionChanged: (value) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  title: const Text(
                    "Macro type",
                    style: TextStyle(fontSize: 22),
                  ),
                  children: [
                    ListTile(
                      title: const Text(
                        "Set individual",
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: const Icon(Icons.category),
                      selected:
                          _macrosSelection == Macros.individual ? true : false,
                      selectedColor: Colors.white,
                      selectedTileColor: _macrosSelection == Macros.individual
                          ? selectedColor
                          : null,
                      onTap: () => _macrosDropdownHandler(Macros.individual),
                    ),
                    ListTile(
                      title: const Text(
                        "Inherit from child components",
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: const Icon(Icons.category),
                      selected:
                          _macrosSelection == Macros.inherit ? true : false,
                      selectedColor: Colors.white,
                      selectedTileColor: _macrosSelection == Macros.inherit
                          ? selectedColor
                          : null,
                      onTap: () => _macrosDropdownHandler(Macros.inherit),
                    ),
                    ListTile(
                      title: const Text(
                        "Both",
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: const Icon(Icons.category),
                      selected: _macrosSelection == Macros.both ? true : false,
                      selectedColor: Colors.white,
                      selectedTileColor: _macrosSelection == Macros.both
                          ? selectedColor
                          : null,
                      onTap: () => _macrosDropdownHandler(Macros.both),
                    ),
                  ],
                ),
              ),
              if (_macrosSelection != Macros.inherit)
                Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ExpansionTile(
                    shape: Border.all(color: Colors.transparent),
                    onExpansionChanged: (value) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    title: const Text(
                      "Macros",
                      style: TextStyle(fontSize: 22),
                    ),
                    children: [
                      const Text(
                        "Macros",
                        style: TextStyle(fontSize: 22),
                      ),
                      _macroTextField(
                        controller: _energyKcalController,
                        setter: (value) => _energyKcal = value,
                        hint: "Kcal",
                        suffixText: null,
                      ),
                      const SizedBox(height: 10.0),
                      _macroTextField(
                        controller: _proteinController,
                        setter: (value) => _protein = value,
                        hint: "Protein",
                      ),
                      const SizedBox(height: 10.0),
                      _macroTextField(
                        controller: _carbohydrateController,
                        setter: (value) => _carbohydrate = value,
                        hint: "Carbohydrate",
                      ),
                      const SizedBox(height: 10.0),
                      _macroTextField(
                        controller: _saltController,
                        setter: (value) => _salt = value,
                        hint: "Salt",
                      ),
                      const SizedBox(height: 10.0),
                      _macroTextField(
                        controller: _sugarController,
                        setter: (value) => _sugar = value,
                        hint: "Sugar",
                      ),
                      const SizedBox(height: 10.0),
                      _macroTextField(
                        controller: _fatController,
                        setter: (value) => _fat = value,
                        hint: "Fat",
                      ),
                      const SizedBox(height: 10.0),
                      _macroTextField(
                        controller: _saturatedFatController,
                        setter: (value) => _saturatedFat = value,
                        hint: "Saturated fat",
                      ),
                      const SizedBox(height: 10.0),
                      _macroTextField(
                        controller: _fiberController,
                        setter: (value) => _fiber = value,
                        hint: "Fiber",
                      ),
                      const SizedBox(height: 10.0),
                      _macroTextField(
                        controller: _organicAcidsController,
                        setter: (value) => _organicAcids = value,
                        hint: "Organic acids",
                      ),
                      const SizedBox(height: 10.0),
                      _macroTextField(
                        controller: _alcoholController,
                        setter: (value) => _alcohol = value,
                        hint: "Alcohol",
                      ),
                      const SizedBox(height: 10.0),
                      _macroTextField(
                        controller: _sugarAlcoholController,
                        setter: (value) => _sugarAlcohol = value,
                        hint: "Sugar alcohol",
                      ),
                    ],
                  ),
                ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: const Text(
                    "Add ingredient +",
                    style: TextStyle(fontSize: 22),
                    // textAlign: TextAlign.center,
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: _addIngredientHandler,
                ),
              ),
              if (_subComponents.isNotEmpty)
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      const Text(
                        "Your added ingredients",
                        style: TextStyle(fontSize: 20),
                      ),
                      ListView.builder(
                        controller: _listScrollController,
                        itemCount: _subComponents.length,
                        // itemCount: 11,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              _subComponents[index].name!,
                              style: const TextStyle(fontSize: 18),
                            ),
                            subtitle: Text(
                              _subComponents[index].description!,
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () =>
                                      _removeIngredient(_subComponents[index]),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 32.0,
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_right)
                              ],
                            ),
                            onTap: () =>
                                _showComponentBreakdown(_subComponents[index]),
                          );
                        },
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _titleTextField => TextField(
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        controller: _titleController,
        keyboardType: TextInputType.text,
        maxLength: 30,
        onChanged: (value) {
          setState(() {
            _isTitleEmpty = _noOnlySpacesRegexp.hasMatch(value);
            _title = value;
          });
        },
        style: TextStyle(
          color: Util.isDark(context) ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
          counterText: "",
          hintText: "Title",
          contentPadding: const EdgeInsets.only(right: 10),
          filled: true,
          // fillColor: const Color(0XDEDEDEDE),
          fillColor: Theme.of(context).colorScheme.secondaryContainer,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 2.0,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 2.0,
            ),
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.only(right: 15.0),
            decoration: BoxDecoration(
              color: _titleController.text.isEmpty
                  ? null
                  : _isTitleEmpty
                      ? Colors.redAccent
                      : Colors.lightGreen,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5.0),
                bottomLeft: Radius.circular(5.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(1),
                  spreadRadius: -1,
                  offset: const Offset(2, 0), // changes position of shadow
                ),
                BoxShadow(
                  // color: const Color(0XDEDEDEDE).withOpacity(1),
                  // color: const Color(0x00E7E0EC).withOpacity(1),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  spreadRadius: 0,
                  offset: const Offset(1, 0), // changes position of shadow
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.short_text,
                size: 30,
              ),
            ),
          ),
        ),
      );

  Widget get _descriptionTextField => TextField(
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        controller: _descriptionController,
        keyboardType: TextInputType.text,
        maxLength: 50,
        onChanged: (value) {
          setState(() {
            _description = value;
          });
        },
        style: TextStyle(
          color: Util.isDark(context) ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
          counterText: "",
          hintText: "Description",
          contentPadding: const EdgeInsets.only(right: 10),
          filled: true,
          // fillColor: const Color(0XDEDEDEDE),
          fillColor: Theme.of(context).colorScheme.secondaryContainer,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 2.0,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 2.0,
            ),
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.only(right: 15.0),
            decoration: BoxDecoration(
              color: _descriptionController.text.isEmpty
                  ? null
                  : Colors.lightGreen,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5.0),
                bottomLeft: Radius.circular(5.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(1),
                  spreadRadius: -1,
                  offset: const Offset(2, 0), // changes position of shadow
                ),
                BoxShadow(
                  // color: const Color(0XDEDEDEDE).withOpacity(1),
                  // color: const Color(0x00E7E0EC).withOpacity(1),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  spreadRadius: 0,
                  offset: const Offset(1, 0), // changes position of shadow
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.description,
                size: 30,
              ),
            ),
          ),
        ),
      );

  Widget _macroTextField({
    required TextEditingController controller,
    required Function setter,
    required String hint,
    String? suffixText = "g",
  }) {
    return TextField(
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(_macroRegExp)],
      onChanged: (value) {
        setState(() {
          if (value.isEmpty) {
            value = '0.0';
          }
          setter(double.tryParse(value.replaceAll(',', '.')));
          print(value);
        });
      },
      style: TextStyle(
        color: Util.isDark(context) ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        counterText: "",
        hintText: hint,
        suffixText: suffixText,
        contentPadding: const EdgeInsets.only(right: 10),
        filled: true,
        // fillColor: const Color(0XDEDEDEDE),
        fillColor: Theme.of(context).colorScheme.secondaryContainer,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 2.0,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 2.0,
          ),
        ),
        prefixIcon: Container(
          margin: const EdgeInsets.only(right: 15.0),
          decoration: BoxDecoration(
            color: controller.text.isEmpty ? null : Colors.lightGreen,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5.0),
              bottomLeft: Radius.circular(5.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(1),
                spreadRadius: -1,
                offset: const Offset(2, 0), // changes position of shadow
              ),
              BoxShadow(
                // color: const Color(0XDEDEDEDE).withOpacity(1),
                // color: const Color(0x00E7E0EC).withOpacity(1),
                color: Theme.of(context).colorScheme.secondaryContainer,
                spreadRadius: 0,
                offset: const Offset(1, 0), // changes position of shadow
              ),
            ],
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              Icons.bar_chart,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
