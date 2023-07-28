import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/widgets/loading_components.dart';

import '../models/component_model.dart';
import '../widgets/no_components_found.dart';
import 'component_breakdown_screen.dart';

class AddExistingComponent extends StatefulWidget {
  const AddExistingComponent({Key? key}) : super(key: key);

  @override
  State<AddExistingComponent> createState() => _AddExistingComponentState();
}

class _AddExistingComponentState extends State<AddExistingComponent> {
  // late List<Component> _selectedComponents;
  late List<Map<String, dynamic>> _amountOfelectedComponents;

  // late List<int> _selectedComponentsIndexes;
  late final ScrollController _listScrollController;
  late final Stream _userComponentsDocStream;
  late final User? _currentUser;

  @override
  void initState() {
    _currentUser = FirebaseAuth.instance.currentUser;
    // _selectedComponents = <Component>[];
    _amountOfelectedComponents = <Map<String, dynamic>>[];
    // _selectedComponentsIndexes = <int>[];
    _listScrollController = ScrollController();
    _userComponentsDocStream = FirebaseFirestore.instance
        .collection("user_components")
        .doc(_currentUser?.uid)
        .snapshots();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    super.dispose();
  }

  // void _addSelection(Component component) {
  void _addSelection(int index, Component component) {
    setState(() {
      // _selectedComponents.add(component);
      // _selectedComponentsIndexes.add(index);
      _amountOfelectedComponents.add({
        "component": component,
        "index": index,
        "amount": 1,
      });
    });
  }

  // void _removeSelection(Component component) {
  void _removeSelection(int index, Component component) {
    setState(() {
      // _selectedComponents.remove(component);
      // _selectedComponentsIndexes.remove(index);
      _amountOfelectedComponents
          .removeWhere((element) => element["index"] == index);
    });
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

  // bool _isSelected(Component component) {
  //   for (var e in _selectedComponents) {
  //     if (e == component) return true;
  //   }
  //   return false;
  // }

  bool _isSelected(int index) {
    // return _selectedComponentsIndexes.contains(index);
    for (Map map in _amountOfelectedComponents) {
      if (map["index"] == index) {
        return true;
      }
    }
    return false;
  }

  int _getIndexInSelectedComponents(Component component) {
    // return _selectedComponents.indexWhere((element) => element == component) + 1;
    return _amountOfelectedComponents
                .where((element) => element["component"] == component).first["index"] +
        1;
  }

  void _increaseAmount(int index) {
    Map map = _amountOfelectedComponents
        .where((element) => element["index"] == index).first;

    setState(() {
      (map["amount"] as int) + 1;
    });
  }

  void _decreaseAmount(int index) {
    Map map = _amountOfelectedComponents
        .where((element) => element["index"] == index).first;

    if (map["amount"] > 1) {
      setState(() {
        (map["amount"] as int) + 1;
      });
    }
  }

  int _getAmountSelected(int index) {
    if (!_isSelected(index)) {
      return 0;
    }
    return _amountOfelectedComponents
            .where((element) => element["index"] == index).first["amount"];
  }

  List<Component> _returnSelectedComponents() {
    List<Component> selectedComponents = [];
    print(_amountOfelectedComponents);
    for (Map map in _amountOfelectedComponents) {
      for (int i = 0; i <= map["amount"]; i++) {
        selectedComponents.add(map["component"]);
      }
    }
    return selectedComponents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            print("here");
            List<Component> selected = _returnSelectedComponents();
            print(selected);
              Navigator.of(context).pop(selected);
          },
          icon: const Icon(Icons.close),
          color: Colors.black,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.check,
              color: Colors.black,
            ),
            // onPressed: () => Navigator.of(context).pop(_selectedComponents),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _userComponentsDocStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Your components could not be displayed"),
                    );
                  }
                  if (snapshot.hasData) {
                    List<Map<String, dynamic>> json = snapshot
                        .data["components"]
                        .cast<Map<String, dynamic>>();
                    List<Component> components =
                        json.map((e) => Component.fromJson(e)).toList();

                    if (components.isEmpty) {
                      return const NoComponentsFound();
                    } else {
                      return ListView.builder(
                        controller: _listScrollController,
                        itemCount: components.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            color: _isSelected(index)
                                ? Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.5)
                                : null,
                            child: ListTile(
                              title: Text(
                                components[index].name!,
                                style: TextStyle(
                                  fontSize: 18,
                                  // color: _isSelected(components[index])
                                  color:
                                      _isSelected(index) ? Colors.white : null,
                                ),
                                // ),
                              ),
                              subtitle: Text(
                                components[index].description!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      _isSelected(index) ? Colors.white : null,
                                ),
                              ),
                              // leading: _selectedComponents.isEmpty ||
                              //         !_selectedComponentsIndexes
                              //             .contains(index)
                              leading: _amountOfelectedComponents.isEmpty ||
                                      !_isSelected(index)
                                  ? null
                                  : Text(
                                      "#${_getIndexInSelectedComponents(components[index])}",
                                      style: const TextStyle(fontSize: 28),
                                    ),
                              trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          if (_isSelected(index)) {
                                            _decreaseAmount(index);
                                          }
                                        },
                                        icon: const Icon(
                                            Icons.keyboard_arrow_left)),
                                    // Text("${components[index].amount}"),
                                    Text("${_getAmountSelected(index)}"),
                                    IconButton(
                                        onPressed: () {
                                          if (!_isSelected(index)) {
                                            _addSelection(
                                                index, components[index]);
                                          } else {
                                            _increaseAmount(index);
                                          }
                                        },
                                        icon: const Icon(
                                            Icons.keyboard_arrow_right)),
                                  ]),
                              onTap: () => _isSelected(index)
                                  ? _removeSelection(index, components[index])
                                  : _addSelection(index, components[index]),
                              onLongPress: () =>
                                  _showComponentBreakdown(components[index]),
                            ),
                          );
                        },
                      );
                    }
                  }
                  return const LoadingComponents();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
