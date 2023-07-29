import 'package:cloud_firestore/cloud_firestore.dart';
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
  static const List<String> _categories = [
    "Component",
    "Breakfast",
    "Lunch",
    "Dinner",
    "Snack"
  ];
  static const double _kJMultiplier = 4.1855;
  Macros? _macrosSelection;
  String? _title, _description, _category, _macrosSelectionText;
  late List<Component>? _subComponents, _selectedComponents;
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
  late final RegExp _macroRegExp;

  @override
  void initState() {
    _isTitleEmpty = true;
    _category = "Component";
    _macrosSelection = Macros.individual;
    _macrosSelectionText = "Individual";
    _subComponents = <Component>[];
    _selectedComponents = <Component>[];
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
    _macroRegExp = RegExp(r"^[1-9]\d*((\.|,)\d?)?");

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
    _energy =
        double.tryParse((_energyKcal! * _kJMultiplier).toStringAsFixed(0)) ??
            0.0;
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
      "name": _title,
      "description": _description,
      "category": _category,
      "macroSelection": _macrosSelectionText,
      "creationDate": Timestamp.now(),
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

  // InputDecoration _textfieldInputDecoration(String hintText) {
  //   return InputDecoration(
  //     suffix: const Text("g"),
  //     errorBorder: OutlineInputBorder(
  //       borderSide: BorderSide(
  //         color: Theme.of(context).primaryColor,
  //         width: 2.0,
  //       ),
  //     ),
  //     focusedBorder: OutlineInputBorder(
  //       borderSide: BorderSide(
  //         color: Theme.of(context).primaryColor,
  //         width: 2.0,
  //       ),
  //     ),
  //     enabledBorder: const OutlineInputBorder(
  //       borderSide: BorderSide(
  //         color: Colors.grey,
  //         width: 2.0,
  //       ),
  //     ),
  //     prefixIcon: Icon(
  //       Icons.title,
  //       color: Theme.of(context).primaryColor,
  //     ),
  //     hintText: hintText,
  //     border: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(5.0),
  //       borderSide: const BorderSide(
  //         width: 2.0,
  //         style: BorderStyle.none,
  //       ),
  //     ),
  //   );
  // }

  double? get _ingredientsTotalEnergy => _selectedComponents
      ?.map((e) => (e.energy ?? 0.0))
      .fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get _ingredientsTotalEnergyKcal => _selectedComponents
      ?.map((e) => (e.energyKcal ?? 0.0))
      .fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get _ingredientsTotalSalt => _selectedComponents
      ?.map((e) => (e.salt ?? 0.0))
      .fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get _ingredientsTotalProtein => _selectedComponents
      ?.map((e) => (e.protein ?? 0.0))
      .fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get _ingredientsTotalCarbohydrate => _selectedComponents
      ?.map((e) => (e.carbohydrate ?? 0.0))
      .fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get _ingredientsTotalAlcohol => _selectedComponents
      ?.map((e) => (e.alcohol ?? 0.0))
      .fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get _ingredientsTotalOrganicAcids => _selectedComponents
      ?.map((e) => (e.organicAcids ?? 0.0))
      .fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get _ingredientsTotalSugarAlcohol => _selectedComponents
      ?.map((e) => (e.sugarAlcohol ?? 0.0))
      .fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get _ingredientsTotalSaturatedFat => _selectedComponents
      ?.map((e) => (e.saturatedFat ?? 0.0))
      .fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get _ingredientsTotalFiber => _selectedComponents
      ?.map((e) => (e.fiber ?? 0.0))
      .fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get _ingredientsTotalSugar => _selectedComponents
      ?.map((e) => (e.sugar ?? 0.0))
      .fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get _ingredientsTotalFat => _selectedComponents
      ?.map((e) => (e.fat ?? 0.0))
      .fold(0.0, (a, b) => (a ?? 0.0) + b);

  void _setEnergyKcal(double value) => _energyKcal = value;

  void _setProtein(double value) => _protein = value;

  void _setCarbohydrate(double value) => _carbohydrate = value;

  void _setSalt(double value) => _salt = value;

  void _setSugar(double value) => _sugar = value;

  void _setFat(double value) => _fat = value;

  void _setSaturatedFat(double value) => _saturatedFat = value;

  void _setFiber(double value) => _fiber = value;

  void _setOrganicAcids(double value) => _organicAcids = value;

  void _setAlcohol(double value) => _alcohol = value;

  void _setSugarAlcohol(double value) => _sugarAlcohol = value;

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
                      // TextField(
                      //   controller: _titleController,
                      //   keyboardType: TextInputType.text,
                      //   onChanged: (value) => setState(() {
                      //     _isTitleEmpty = _noOnlySpacesRegexp.hasMatch(value);
                      //     print("TITLE IS EMPTY: $_isTitleEmpty");
                      //     _title = value;
                      //   }),
                      //   decoration: InputDecoration(
                      //     errorText: (_titleController.text.isEmpty || !_isTitleEmpty)
                      //         ? null
                      //         : "Title must not be empty",
                      //     errorBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: _titleController.text.isEmpty ? Colors.grey : Colors.red,
                      //         width: 2.0,
                      //       ),
                      //     ),
                      //     focusedBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: Theme.of(context).primaryColor,
                      //         width: 2.0,
                      //       ),
                      //     ),
                      //     enabledBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: Theme.of(context).primaryColor,
                      //         width: 2.0,
                      //       ),
                      //     ),
                      //     prefixIcon: Icon(
                      //       Icons.title,
                      //       color: Theme.of(context).primaryColor,
                      //     ),
                      //     hintText: "Title",
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(5.0),
                      //       borderSide: const BorderSide(
                      //         width: 2.0,
                      //         style: BorderStyle.none,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 5.0,
                      // ),
                      // TextField(
                      //   maxLength: 99,
                      //   controller: _descriptionController,
                      //   keyboardType: TextInputType.text,
                      //   onChanged: (value) => setState(() {
                      //     _description = value;
                      //   }),
                      //   decoration: InputDecoration(
                      //     enabledBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: Theme.of(context).primaryColor,
                      //         width: 2.0,
                      //       ),
                      //     ),
                      //     prefixIcon: Icon(
                      //       Icons.description,
                      //       color: Theme.of(context).primaryColor,
                      //     ),
                      //     hintText: "Description",
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(5.0),
                      //       borderSide: const BorderSide(
                      //         width: 2.0,
                      //         style: BorderStyle.none,
                      //       ),
                      //     ),
                      //   ),
                      // ),
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
                        selectedTileColor: _category == category
                            ? Theme.of(context).primaryColor.withOpacity(0.5)
                            : null,
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
                          ? Theme.of(context).primaryColor.withOpacity(0.5)
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
                          ? Theme.of(context).primaryColor.withOpacity(0.5)
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
                          ? Theme.of(context).primaryColor.withOpacity(0.5)
                          : null,
                      onTap: () => _macrosDropdownHandler(Macros.both),
                    ),
                  ],
                ),
              ),
              if (_macrosSelection != null &&
                  _macrosSelection != Macros.inherit)
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
                        setter: _setEnergyKcal,
                        hint: "Kcal",
                        suffixText: null,
                      ),
                      const SizedBox(height: 10.0),
                      _macroTextField(
                        controller: _proteinController,
                        setter: _setProtein,
                        hint: "Protein",
                      ),
                      const SizedBox(height: 10.0),
                      _macroTextField(
                        controller: _carbohydrateController,
                        setter: _setCarbohydrate,
                        hint: "Carbohydrate",
                      ),
                      const SizedBox(height: 10.0),
                      _macroTextField(
                        controller: _saltController,
                        setter: _setSalt,
                        hint: "Salt",
                      ),
                      const SizedBox(height: 10.0),
                      _macroTextField(
                        controller: _sugarController,
                        setter: _setSugar,
                        hint: "Sugar",
                      ),
                      const SizedBox(height: 10.0),
                      _macroTextField(
                        controller: _fatController,
                        setter: _setFat,
                        hint: "Fat",
                      ),
                      const SizedBox(height: 10.0),
                      _macroTextField(
                        controller: _saturatedFatController,
                        setter: _setSaturatedFat,
                        hint: "Saturated fat",
                      ),
                      const SizedBox(height: 10.0),
                      _macroTextField(
                        controller: _fiberController,
                        setter: _setFiber,
                        hint: "Fiber",
                      ),
                      const SizedBox(height: 10.0),
                      _macroTextField(
                        controller: _organicAcidsController,
                        setter: _setOrganicAcids,
                        hint: "Organic acids",
                      ),
                      const SizedBox(height: 10.0),
                      _macroTextField(
                        controller: _alcoholController,
                        setter: _setAlcohol,
                        hint: "Alcohol",
                      ),
                      const SizedBox(height: 10.0),
                      _macroTextField(
                        controller: _sugarAlcoholController,
                        setter: _setSugarAlcohol,
                        hint: "Sugar alcohol",
                      ),
                      // const SizedBox(height: 10.0),
                      // TextField(
                      //   controller: _energyKcalController,
                      //   keyboardType: TextInputType.number,
                      //   inputFormatters: [
                      //     FilteringTextInputFormatter.digitsOnly,
                      //     FilteringTextInputFormatter.deny(_noLeadingZeroRegexp,
                      //         replacementString: _energyKcalController.text),
                      //   ],
                      //   onChanged: (value) => setState(() {
                      //     _energyKcal = double.tryParse(value);
                      //   }),
                      //   decoration: _textfieldInputDecoration("Kcal"),
                      // ),
                      // const SizedBox(height: 10.0),
                      // TextField(
                      //   controller: _proteinController,
                      //   keyboardType: TextInputType.number,
                      //   inputFormatters: [
                      //     FilteringTextInputFormatter.digitsOnly,
                      //     FilteringTextInputFormatter.deny(_noLeadingZeroRegexp,
                      //         replacementString: _proteinController.text),
                      //   ],
                      //   onChanged: (value) => setState(() {
                      //     _protein = double.tryParse(value);
                      //   }),
                      //   decoration: _textfieldInputDecoration("Protein"),
                      // ),
                      // const SizedBox(height: 10.0),
                      // TextField(
                      //   controller: _carbohydrateController,
                      //   keyboardType: TextInputType.number,
                      //   inputFormatters: [
                      //     FilteringTextInputFormatter.digitsOnly,
                      //     FilteringTextInputFormatter.deny(_noLeadingZeroRegexp,
                      //         replacementString: _carbohydrateController.text),
                      //   ],
                      //   onChanged: (value) => setState(() {
                      //     _carbohydrate = double.tryParse(value);
                      //   }),
                      //   decoration: _textfieldInputDecoration("Carbohydrates"),
                      // ),
                      // const SizedBox(height: 10.0),
                      // TextField(
                      //   controller: _saltController,
                      //   keyboardType: TextInputType.number,
                      //   inputFormatters: [
                      //     FilteringTextInputFormatter.digitsOnly,
                      //     FilteringTextInputFormatter.deny(_noLeadingZeroRegexp,
                      //         replacementString: _saltController.text),
                      //   ],
                      //   onChanged: (value) => setState(() {
                      //     _salt = double.tryParse(value);
                      //   }),
                      //   decoration: _textfieldInputDecoration("Salt"),
                      // ),
                      // const SizedBox(height: 10.0),
                      // TextField(
                      //   controller: _sugarController,
                      //   keyboardType: TextInputType.number,
                      //   inputFormatters: [
                      //     FilteringTextInputFormatter.digitsOnly,
                      //     FilteringTextInputFormatter.deny(_noLeadingZeroRegexp,
                      //         replacementString: _sugarController.text),
                      //   ],
                      //   onChanged: (value) => setState(() {
                      //     _sugar = double.tryParse(value);
                      //   }),
                      //   decoration: _textfieldInputDecoration("Sugar"),
                      // ),
                      // const SizedBox(height: 10.0),
                      // TextField(
                      //   controller: _fatController,
                      //   keyboardType: TextInputType.number,
                      //   inputFormatters: [
                      //     FilteringTextInputFormatter.digitsOnly,
                      //     FilteringTextInputFormatter.deny(_noLeadingZeroRegexp,
                      //         replacementString: _fatController.text),
                      //   ],
                      //   onChanged: (value) => setState(() {
                      //     _fat = double.tryParse(value);
                      //   }),
                      //   decoration: _textfieldInputDecoration("Fat"),
                      // ),
                      // const SizedBox(height: 10.0),
                      // TextField(
                      //   controller: _saturatedFatController,
                      //   keyboardType: TextInputType.number,
                      //   inputFormatters: [
                      //     FilteringTextInputFormatter.digitsOnly,
                      //     FilteringTextInputFormatter.deny(_noLeadingZeroRegexp,
                      //         replacementString: _saturatedFatController.text),
                      //   ],
                      //   onChanged: (value) => setState(() {
                      //     _saturatedFat = double.tryParse(value);
                      //   }),
                      //   decoration: _textfieldInputDecoration("Saturated fat"),
                      // ),
                      // const SizedBox(height: 10.0),
                      // TextField(
                      //   controller: _fiberController,
                      //   keyboardType: TextInputType.number,
                      //   inputFormatters: [
                      //     FilteringTextInputFormatter.digitsOnly,
                      //     FilteringTextInputFormatter.deny(_noLeadingZeroRegexp,
                      //         replacementString: _fiberController.text),
                      //   ],
                      //   onChanged: (value) => setState(() {
                      //     _fiber = double.tryParse(value);
                      //   }),
                      //   decoration: _textfieldInputDecoration("Fiber"),
                      // ),
                      // const SizedBox(height: 10.0),
                      // TextField(
                      //   controller: _organicAcidsController,
                      //   keyboardType: TextInputType.number,
                      //   inputFormatters: [
                      //     FilteringTextInputFormatter.digitsOnly,
                      //     FilteringTextInputFormatter.deny(_noLeadingZeroRegexp,
                      //         replacementString: _organicAcidsController.text),
                      //   ],
                      //   onChanged: (value) => setState(() {
                      //     _organicAcids = double.tryParse(value);
                      //   }),
                      //   decoration: _textfieldInputDecoration("Organic acids"),
                      // ),
                      // const SizedBox(height: 10.0),
                      // TextField(
                      //   controller: _alcoholController,
                      //   keyboardType: TextInputType.number,
                      //   inputFormatters: [
                      //     FilteringTextInputFormatter.digitsOnly,
                      //     FilteringTextInputFormatter.deny(_noLeadingZeroRegexp,
                      //         replacementString: _alcoholController.text),
                      //   ],
                      //   onChanged: (value) => setState(() {
                      //     _alcohol = double.tryParse(value);
                      //   }),
                      //   decoration: _textfieldInputDecoration("Alcohol"),
                      // ),
                      // const SizedBox(height: 10.0),
                      // TextField(
                      //   controller: _sugarAlcoholController,
                      //   keyboardType: TextInputType.number,
                      //   inputFormatters: [
                      //     FilteringTextInputFormatter.digitsOnly,
                      //     FilteringTextInputFormatter.deny(_noLeadingZeroRegexp,
                      //         replacementString: _sugarAlcoholController.text),
                      //   ],
                      //   onChanged: (value) => setState(() {
                      //     _sugarAlcohol = double.tryParse(value);
                      //   }),
                      //   decoration: _textfieldInputDecoration("Sugar alcohol"),
                      // ),
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
              if (_subComponents != null && _subComponents!.isNotEmpty)
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
                                  onPressed: () =>
                                      _removeIngredient(_subComponents![index]),
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
                                _showComponentBreakdown(_subComponents![index]),
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
        print(value);
        setState(() {
          if (value.isNotEmpty) {
            setter(double.tryParse(value.replaceAll(',', '.')));
          }
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
