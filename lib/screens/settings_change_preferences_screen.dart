import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:health_companion/util.dart';
import 'package:health_companion/services/firebase_service.dart';
import 'package:health_companion/models/user_preferences_model.dart';

class EditPreferences extends StatefulWidget {
  const EditPreferences({Key? key}) : super(key: key);

  @override
  State<EditPreferences> createState() => _EditPreferencesState();
}

class _EditPreferencesState extends State<EditPreferences> {
  late final ScrollController _listScrollController;
  late final TextEditingController _macroTextFieldController;

  // late final Map<String, String> _preferences;
  late final Stream _userPreferencesDocStream;
  late final User _currentUser;
  DateTime? _buttonPressed;
  late UserPreferences _userPreferences;
  late final List<String> _keys;

  @override
  void initState() {
    _currentUser = FirebaseAuth.instance.currentUser!;
    _userPreferencesDocStream = FirebaseFirestore.instance
        .collection("user_preferences")
        .doc(_currentUser.uid)
        .snapshots();
    // _preferences = {
    //   "Alcohol": "alcohol",
    //   "Carbohydrate": "carbohydrate",
    //   "Energy kJ": "energyKj",
    //   "Energy kcal": "energyKcal",
    //   "Fat": "fat",
    //   "Fiber": "fiber",
    //   "Organic acids": "organicAcids",
    //   "Protein": "protein",
    //   "Salt": "salt",
    //   "Saturated fat": "saturatedFat",
    //   "Sugar alcohol": "sugarAlcohol",
    //   "Sugar": "sugar",
    // };
    // _preferences = {
    //   "alcohol": "alcohol",
    //   "carbohydrate": "carbohydrate",
    //   "energykj": "energyKj",
    //   "energykcal": "energyKcal",
    //   "fat": "fat",
    //   "fiber": "fiber",
    //   "organicAcids": "organicAcids",
    //   "protein": "protein",
    //   "salt": "salt",
    //   "saturatedFat": "saturatedFat",
    //   "sugarAlcohol": "sugarAlcohol",
    //   "sugar": "sugar",
    // };
    _keys = [
      'alcohol',
      'carbohydrate',
      'energyKj',
      'energyKcal',
      'fat',
      'fiber',
      'organicAcids',
      'protein',
      'salt',
      'saturatedFat',
      'sugarAlcohol',
      'sugar'
    ];
    _listScrollController = ScrollController();
    _macroTextFieldController = TextEditingController();
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
    super.dispose();
  }

  void _updatePreferences(Map<String, int> data) {
    int value = data.values.first;
    bool isSameData = false;

    switch (data.keys.first) {
      case 'alcohol':
        isSameData = value == _userPreferences.alcohol;
        break;
      case 'carbohydrate':
        isSameData = value == _userPreferences.carbohydrate;
        break;
      case 'energyKj':
        isSameData = value == _userPreferences.energyKj;
        break;
      case 'energyKcal':
        isSameData = value == _userPreferences.energyKcal;
        break;
      case 'fat':
        isSameData = value == _userPreferences.fat;
        break;
      case 'fiber':
        isSameData = value == _userPreferences.fiber;
        break;
      case 'organicAcids':
        isSameData = value == _userPreferences.organicAcids;
        break;
      case 'protein':
        isSameData = value == _userPreferences.protein;
        break;
      case 'salt':
        isSameData = value == _userPreferences.salt;
        break;
      case 'saturatedFat':
        isSameData = value == _userPreferences.saturatedFat;
        break;
      case 'sugarAlcohol':
        isSameData = value == _userPreferences.sugarAlcohol;
        break;
      case 'sugar':
        isSameData = value == _userPreferences.sugar;
        break;
    }

    if (!isSameData) {
      FirebaseService.updateUserPreferences(data);
    }
  }

  Future<int?> _dialogBuilder(BuildContext context, String title, String suffix) {
    return showDialog<int?>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        var width = MediaQuery.of(context).size.width;

        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          title: Text('${AppLocalizations.of(context)!.set} ${title.toLowerCase()}'),
          content: SizedBox(
            width: width,
            child: _macroTextField(suffixText: suffix),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () {
                _macroTextFieldController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(AppLocalizations.of(context)!.confirm),
              onPressed: () {
                int value = int.tryParse(_macroTextFieldController.text) ?? 0;
                _macroTextFieldController.clear();
                Navigator.of(context).pop(value);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _macroTextField({
    String? suffixText = "g",
  }) {
    return TextField(
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: _macroTextFieldController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      // inputFormatters: [FilteringTextInputFormatter.allow(_macroRegExp)],
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: TextStyle(
        color: Util.isDark(context) ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        counterText: "",
        // hintText: hint,
        suffixText: suffixText,
        contentPadding: const EdgeInsets.only(right: 10),
        filled: true,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: StreamBuilder(
          stream: _userPreferencesDocStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error"),
              );
            }
            if (snapshot.hasData) {
              Map<String, dynamic> data = snapshot.data.data();
              _userPreferences = UserPreferences.fromJson(data);

              return Card(
                clipBehavior: Clip.antiAlias,
                child: ListView.builder(
                  controller: _listScrollController,
                  // itemCount: _preferences.keys.length,
                  itemCount: _keys.length,
                  itemBuilder: (context, index) {
                    // String title = _preferences.keys.elementAt(index);
                    // String title = _keys[index];
                    String title = AppLocalizations.of(context)!.macro(_keys[index].toLowerCase());
                    // String dataKey = _preferences.values.elementAt(index);
                    int limit = data[_keys[index]];
                    String suffix = 'g';
                    // print(title.contains('energy'));
                    if (_keys[index].toLowerCase().contains('energy')) {
                      suffix =
                          _keys[index].toLowerCase().contains('kcal') ? 'kcal' : 'kJ';
                    }

                    return ListTile(
                      title: Text(title),
                      // subtitle: Text("Current limit is $limit $suffix"),
                      subtitle: Text(AppLocalizations.of(context)!
                          .currentLimitIs("$limit $suffix")),
                      onTap: () async {
                        int? value = await _dialogBuilder(context, title, suffix);
                        if (value != null) {
                          // _updatePreferences({dataKey: value});
                          _updatePreferences({_keys[index]: value});
                        }
                      },
                      trailing: TextButton(
                        // onPressed: () => _updatePreferences({dataKey: 0}),
                        onPressed: () => _updatePreferences({_keys[index]: 0}),
                        child: Text(AppLocalizations.of(context)!.reset),
                      ),
                    );
                  },
                ),
              );
            }
            return const Center(
              child: Text("Loading"),
            );
          },
        ),
      ),
    );
  }
}
