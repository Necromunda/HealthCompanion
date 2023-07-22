import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_companion/screens/add_existing_component_screen.dart';
import 'package:intl/intl.dart';

import '../models/component_model.dart';
import '../util.dart';
import 'component_breakdown_screen.dart';

enum Macros { individual, inherit, both }

class AddNewComponent extends StatefulWidget {
  const AddNewComponent({Key? key}) : super(key: key);

  @override
  State<AddNewComponent> createState() => _AddNewComponentState();
}

class _AddNewComponentState extends State<AddNewComponent> {
  static final RegExp _noLeadingZeroRegexp = RegExp(r'^0[0-9]+');
  static final RegExp _noOnlySpacesRegexp = RegExp(r'^\s*$');
  static const List<String> _categories = ["Component", "Breakfast", "Lunch", "Dinner", "Snack"];
  static const double _kJMultiplier = 4.1855;
  Macros? _macrosSelection;
  String? _name, _description, _category, _macrosSelectionText;
  late List<Component>? _subComponents, _selectedComponents;
  late final ScrollController _listScrollController;
  late final TextEditingController _nameController,
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
  late bool _isTitleEmpty;

  @override
  void initState() {
    _isTitleEmpty = true;
    _category = "Component";
    _macrosSelection = Macros.individual;
    _macrosSelectionText = "Individual";
    _subComponents = <Component>[];
    _selectedComponents = <Component>[];
    _listScrollController = ScrollController();
    _nameController = TextEditingController();
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
          _macrosSelectionText = "ingredients excluded";
          break;
        case Macros.inherit:
          _macrosSelection = Macros.inherit;
          _macrosSelectionText = "ingredients included";
          break;
        case Macros.both:
          _macrosSelection = Macros.both;
          _macrosSelectionText = "ingredients included";
          break;
      }
    });
  }

  Component _createComponent() {
    _energyKcal ??= 0.0;
    _energy = double.tryParse((_energyKcal! * _kJMultiplier).toStringAsFixed(0)) ?? 0.0;
    _salt ??= 0.0;
    _protein ??= 0.0;
    _carbohydrate ??= 0.0;
    _alcohol ??= 0.0;
    _organicAcids ??= 0.0;
    _sugarAlcohol ??= 0.0;
    _saturatedFat ??= 0.0;
    _fiber ??= 0.0;
    _sugar ??= 0.0;
    _fat ??= 0.0;
    Map<String, dynamic> data = {
      "name": _name,
      "description": _description,
      "category": _category,
      "macroSelection": _macrosSelectionText,
      "subComponents": _subComponents?.map((e) => e.toJson()).toList(),
      "salt": _salt,
      "energy": _energy,
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
      double totalEnergyKj = _ingredientsTotalEnergy ?? 0.0;
      double totalEnergyKcal = _ingredientsTotalEnergyKcal ?? 0.0;
      double totalSalt = _ingredientsTotalSalt ?? 0.0;
      double totalProtein = _ingredientsTotalProtein ?? 0.0;
      double totalCarbohydrate = _ingredientsTotalCarbohydrate ?? 0.0;
      double totalAlcohol = _ingredientsTotalAlcohol ?? 0.0;
      double totalOrganicAcids = _ingredientsTotalOrganicAcids ?? 0.0;
      double totalSugarAlcohol = _ingredientsTotalSugarAlcohol ?? 0.0;
      double totalSaturatedFat = _ingredientsTotalSaturatedFat ?? 0.0;
      double totalFiber = _ingredientsTotalFiber ?? 0.0;
      double totalSugar = _ingredientsTotalSugar ?? 0.0;
      double totalFat = _ingredientsTotalFat ?? 0.0;
      if (_macrosSelection == Macros.inherit) {
        data["energy"] = totalEnergyKj;
        data["energyKcal"] = totalEnergyKcal;
        data["salt"] = totalSalt;
        data["protein"] = totalProtein;
        data["carbohydrate"] = totalCarbohydrate;
        data["alcohol"] = totalAlcohol;
        data["organicAcids"] = totalOrganicAcids;
        data["sugarAlcohol"] = totalSugarAlcohol;
        data["saturatedFat"] = totalSaturatedFat;
        data["fiber"] = totalFiber;
        data["sugar"] = totalSugar;
        data["fat"] = totalFat;
      } else {
        data["energy"] = _energy! + totalEnergyKj;
        data["energyKcal"] = _energyKcal! + totalEnergyKcal;
        data["salt"] = _salt! + totalSalt;
        data["protein"] = _protein! + totalProtein;
        data["carbohydrate"] = _carbohydrate! + totalCarbohydrate;
        data["alcohol"] = _alcohol! + totalAlcohol;
        data["organicAcids"] = _organicAcids! + totalOrganicAcids;
        data["sugarAlcohol"] = _sugarAlcohol! + totalSugarAlcohol;
        data["saturatedFat"] = _saturatedFat! + totalSaturatedFat;
        data["fiber"] = _fiber! + totalFiber;
        data["sugar"] = _sugar! + totalSugar;
        data["fat"] = _fat! + totalFat;
      }
    } else {
      data["energy"] = _energy;
    }
    return Component.fromJson(data);
  }

  void _addIngredientHandler() async {
    FocusManager.instance.primaryFocus?.unfocus();
    _selectedComponents = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddExistingComponent(),
      ),
    );
    setState(() {
      if (_selectedComponents != null) {
        _subComponents?.addAll(_selectedComponents!.cast<Component>());
      }
    });
  }

  void _removeIngredient(Component component) {
    setState(() {
      _subComponents!.remove(component);
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

  InputDecoration _textfieldInputDecoration(String hintText) {
    return InputDecoration(
      suffix: const Text("g"),
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
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(
          width: 2.0,
          style: BorderStyle.none,
        ),
      ),
    );
  }

  double? get _ingredientsTotalEnergy =>
      _selectedComponents?.map((e) => (e.energy ?? 0.0)).fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get _ingredientsTotalEnergyKcal =>
      _selectedComponents?.map((e) => (e.energyKcal ?? 0.0)).fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get _ingredientsTotalSalt =>
      _selectedComponents?.map((e) => (e.salt ?? 0.0)).fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get _ingredientsTotalProtein =>
      _selectedComponents?.map((e) => (e.protein ?? 0.0)).fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get _ingredientsTotalCarbohydrate =>
      _selectedComponents?.map((e) => (e.carbohydrate ?? 0.0)).fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get _ingredientsTotalAlcohol =>
      _selectedComponents?.map((e) => (e.alcohol ?? 0.0)).fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get _ingredientsTotalOrganicAcids =>
      _selectedComponents?.map((e) => (e.organicAcids ?? 0.0)).fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get _ingredientsTotalSugarAlcohol =>
      _selectedComponents?.map((e) => (e.sugarAlcohol ?? 0.0)).fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get _ingredientsTotalSaturatedFat =>
      _selectedComponents?.map((e) => (e.saturatedFat ?? 0.0)).fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get _ingredientsTotalFiber =>
      _selectedComponents?.map((e) => (e.fiber ?? 0.0)).fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get _ingredientsTotalSugar =>
      _selectedComponents?.map((e) => (e.sugar ?? 0.0)).fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get _ingredientsTotalFat =>
      _selectedComponents?.map((e) => (e.fat ?? 0.0)).fold(0.0, (a, b) => (a ?? 0.0) + b);

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
            onPressed: () async {
              _isTitleEmpty
                  ? Util.showNotification(context: context, message: "Title must not be empty")
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
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        onChanged: (value) => setState(() {
                          _isTitleEmpty = _noOnlySpacesRegexp.hasMatch(value);
                          print("TITLE IS EMPTY: $_isTitleEmpty");
                          _name = value;
                        }),
                        decoration: InputDecoration(
                          errorText: (_nameController.text.isEmpty || !_isTitleEmpty)
                              ? null
                              : "Title must not be empty",
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _nameController.text.isEmpty ? Colors.grey : Colors.red,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
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
                      const SizedBox(
                        height: 5.0,
                      ),
                      TextField(
                        maxLength: 99,
                        controller: _descriptionController,
                        keyboardType: TextInputType.text,
                        onChanged: (value) => setState(() {
                          _description = value;
                        }),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2.0,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.description,
                            color: Theme.of(context).primaryColor,
                          ),
                          hintText: "Description",
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
              Card(
                // elevation: 0,
                child: ExpansionTile(
                  onExpansionChanged: (value) => FocusManager.instance.primaryFocus?.unfocus(),
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
                // elevation: 0,
                child: ExpansionTile(
                  onExpansionChanged: (value) => FocusManager.instance.primaryFocus?.unfocus(),
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
                  child: ExpansionTile(
                    onExpansionChanged: (value) => FocusManager.instance.primaryFocus?.unfocus(),
                    title: const Text(
                      "Macros",
                      style: TextStyle(fontSize: 22),
                    ),
                    children: [
                      const Text(
                        "Macros",
                        style: TextStyle(fontSize: 22),
                      ),
                      TextField(
                        controller: _energyKcalController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.deny(_noLeadingZeroRegexp,
                              replacementString: _energyKcalController.text),
                        ],
                        onChanged: (value) => setState(() {
                          _energyKcal = double.tryParse(value);
                        }),
                        decoration: _textfieldInputDecoration("Kcal"),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        controller: _proteinController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.deny(_noLeadingZeroRegexp,
                              replacementString: _proteinController.text),
                        ],
                        onChanged: (value) => setState(() {
                          _protein = double.tryParse(value);
                        }),
                        decoration: _textfieldInputDecoration("Protein"),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        controller: _carbohydrateController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.deny(_noLeadingZeroRegexp,
                              replacementString: _carbohydrateController.text),
                        ],
                        onChanged: (value) => setState(() {
                          _carbohydrate = double.tryParse(value);
                        }),
                        decoration: _textfieldInputDecoration("Carbohydrates"),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        controller: _saltController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.deny(_noLeadingZeroRegexp,
                              replacementString: _saltController.text),
                        ],
                        onChanged: (value) => setState(() {
                          _salt = double.tryParse(value);
                        }),
                        decoration: _textfieldInputDecoration("Salt"),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        controller: _sugarController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.deny(_noLeadingZeroRegexp,
                              replacementString: _sugarController.text),
                        ],
                        onChanged: (value) => setState(() {
                          _sugar = double.tryParse(value);
                        }),
                        decoration: _textfieldInputDecoration("Sugar"),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        controller: _fatController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.deny(_noLeadingZeroRegexp,
                              replacementString: _fatController.text),
                        ],
                        onChanged: (value) => setState(() {
                          _fat = double.tryParse(value);
                        }),
                        decoration: _textfieldInputDecoration("Fat"),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        controller: _saturatedFatController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.deny(_noLeadingZeroRegexp,
                              replacementString: _saturatedFatController.text),
                        ],
                        onChanged: (value) => setState(() {
                          _saturatedFat = double.tryParse(value);
                        }),
                        decoration: _textfieldInputDecoration("Saturated fat"),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        controller: _fiberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.deny(_noLeadingZeroRegexp,
                              replacementString: _fiberController.text),
                        ],
                        onChanged: (value) => setState(() {
                          _fiber = double.tryParse(value);
                        }),
                        decoration: _textfieldInputDecoration("Fiber"),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        controller: _organicAcidsController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.deny(_noLeadingZeroRegexp,
                              replacementString: _organicAcidsController.text),
                        ],
                        onChanged: (value) => setState(() {
                          _organicAcids = double.tryParse(value);
                        }),
                        decoration: _textfieldInputDecoration("Organic acids"),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        controller: _alcoholController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.deny(_noLeadingZeroRegexp,
                              replacementString: _alcoholController.text),
                        ],
                        onChanged: (value) => setState(() {
                          _alcohol = double.tryParse(value);
                        }),
                        decoration: _textfieldInputDecoration("Alcohol"),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        controller: _sugarAlcoholController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.deny(_noLeadingZeroRegexp,
                              replacementString: _sugarAlcoholController.text),
                        ],
                        onChanged: (value) => setState(() {
                          _sugarAlcohol = double.tryParse(value);
                        }),
                        decoration: _textfieldInputDecoration("Sugar alcohol"),
                      ),
                    ],
                  ),
                ),
              Card(
                child: ListTile(
                  title: const Text(
                    "Add ingredient +",
                    style: TextStyle(fontSize: 22),
                    // textAlign: TextAlign.center,
                  ),
                  trailing: const Icon(Icons.launch),
                  onTap: _addIngredientHandler,
                ),
              ),
              if (_subComponents != null && _subComponents!.isNotEmpty)
                Card(
                  child: Column(
                    children: [
                      const Text(
                        "Your added ingredients",
                        style: TextStyle(fontSize: 20),
                      ),
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
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => _removeIngredient(_subComponents![index]),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 32.0,
                                  ),
                                ),
                                const Icon(Icons.launch)
                              ],
                            ),
                            onTap: () => _showComponentBreakdown(_subComponents![index]),
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
}
