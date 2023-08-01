import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_companion/models/component_model.dart';
import 'package:health_companion/services/firebase_service.dart';

import '../util.dart';

class EditPreferences extends StatefulWidget {
  const EditPreferences({Key? key}) : super(key: key);

  @override
  State<EditPreferences> createState() => _EditPreferencesState();
}

class _EditPreferencesState extends State<EditPreferences> {
  late final ScrollController _listScrollController;
  late final TextEditingController _macroTextFieldController;
  late final Map<String, String> _preferences;
  late final Stream _userPreferencesDocStream;
  late final User _currentUser;
  late DateTime? _buttonPressed;

  @override
  void initState() {
    _currentUser = FirebaseAuth.instance.currentUser!;
    _userPreferencesDocStream = FirebaseFirestore.instance
        .collection("user_preferences")
        .doc(_currentUser.uid)
        .snapshots();
    _preferences = {
      "Alcohol": "alcohol",
      "Carbohydrate": "carbohydrate",
      "Energy kJ": "energyKj",
      "Energy kcal": "energyKcal",
      "Fat": "fat",
      "Fiber": "fiber",
      "Organic acids": "organicAcids",
      "Protein": "protein",
      "Salt": "salt",
      "Saturated fat": "saturatedFat",
      "Sugar alcohol": "sugarAlcohol",
      "Sugar": "sugar",
    };
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

  Duration? get timeBetweenButtonPresses => _buttonPressed?.difference(DateTime.now());

  void _updatePreferences(Map<String, int> data) {
    Duration? time = timeBetweenButtonPresses;

    if (time != null && time.inSeconds < 10) {
      print(time);
    } else {
      _buttonPressed = DateTime.now();
      FirebaseService.updateUserPreferences(data);
    }
  }

  Future<int?> _dialogBuilder(BuildContext context, String title) {
    return showDialog<int?>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        var width = MediaQuery.of(context).size.width;
        String? suffix = title.toLowerCase().contains("energy") ? null : "g";

        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          title: Text('Change ${title.toLowerCase()}'),
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
              child: const Text('Cancel'),
              onPressed: () {
                _macroTextFieldController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Confirm'),
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

              return Card(
                clipBehavior: Clip.antiAlias,
                child: ListView.builder(
                  controller: _listScrollController,
                  itemCount: _preferences.keys.length,
                  itemBuilder: (context, index) {
                    String title = _preferences.keys.elementAt(index);
                    String dataKey = _preferences.values.elementAt(index);
                    int goal = data[dataKey];
                    String suffix = 'g';
                    if (title.toLowerCase().contains('energy')) {
                      suffix =
                          title.toLowerCase().contains('kcal') ? 'kcal' : 'kJ';
                    }

                    return ListTile(
                      title: Text(title),
                      subtitle: Text("Current goal is $goal $suffix"),
                      onTap: () async {
                        int? value = await _dialogBuilder(context, title);
                        if (value != null) {
                          _updatePreferences({dataKey: value});
                        }
                      },
                      trailing: TextButton(
                          onPressed: () => _updatePreferences({dataKey: 0}),
                          child: const Text("Reset")),
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
