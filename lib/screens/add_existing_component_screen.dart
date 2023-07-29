import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/util.dart';
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
  late List<Map<String, dynamic>> _selectedComponents;
  late final ScrollController _listScrollController;
  late final Stream _userComponentsDocStream;
  late final User? _currentUser;
  late List<Component> _userComponents;

  @override
  void initState() {
    _currentUser = FirebaseAuth.instance.currentUser;
    _userComponents = <Component>[];
    _selectedComponents = <Map<String, dynamic>>[];
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

  void _addSelection(int index) {
    setState(() {
      _selectedComponents.add({
        "component": _userComponents[index],
        "index": index,
        "amount": 1,
      });
    });
  }

  void _removeSelection(int index) {
    setState(() {
      _selectedComponents.removeWhere((element) => element["index"] == index);
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

  bool _isSelected(int index) {
    for (Map map in _selectedComponents) {
      if (map["index"] == index) {
        return true;
      }
    }
    return false;
  }

  int _getIndexInSelectedComponents(Component component) {
    return _selectedComponents
            .indexWhere((element) => element["component"] == component) +
        1;
  }

  void _increaseAmount(int index) {
    Map map =
        _selectedComponents.where((element) => element["index"] == index).first;

    setState(() {
      map["amount"] += 1;
    });
  }

  void _decreaseAmount(int index) {
    Map map =
        _selectedComponents.where((element) => element["index"] == index).first;

    if (map["amount"] == 1) {
      _removeSelection(index);
    } else if (map["amount"] > 1) {
      setState(() {
        map["amount"] -= 1;
      });
    }
  }

  int _getAmountSelected(int index) {
    if (!_isSelected(index)) {
      return 0;
    }
    return _selectedComponents
        .where((element) => element["index"] == index)
        .first["amount"];
  }

  List<Component> _returnSelectedComponents() {
    List<Component> components = [];

    for (Map map in _selectedComponents) {
      for (int i = 1; i <= map["amount"]; i++) {
        components.add(map["component"]);
      }
    }
    return components;
  }

  Color? get selectedColor => Util.isDark(context)
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
          // color: Colors.black,
        ),
        actions: <Widget>[
          if (_selectedComponents.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.check,
                // color: Colors.black,
              ),
              onPressed: () {
                List<Component> selected = _returnSelectedComponents();
                Navigator.of(context).pop(selected);
              },
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
                    _userComponents =
                        json.map((e) => Component.fromJson(e)).toList();

                    if (_userComponents.isEmpty) {
                      return const NoComponentsFound();
                    } else {
                      return ListView.builder(
                        controller: _listScrollController,
                        itemCount: _userComponents.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Card(
                            clipBehavior: Clip.antiAlias,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            // color: _isSelected(index)
                            //     ? Theme.of(context)
                            //         .colorScheme.primary
                            //     : null,
                            color: _isSelected(index) ? selectedColor : null,
                            child: ListTile(
                              title: Text(
                                _userComponents[index].name!,
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      _isSelected(index) ? Colors.white : null,
                                ),
                              ),
                              subtitle: Text(
                                _userComponents[index].description!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      _isSelected(index) ? Colors.white : null,
                                ),
                              ),
                              leading: _selectedComponents.isEmpty ||
                                      !_isSelected(index)
                                  ? null
                                  : Text(
                                      "#${_getIndexInSelectedComponents(_userComponents[index])}",
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
                                      Icons.keyboard_arrow_left,
                                      size: 32,
                                    ),
                                  ),
                                  Text(
                                    "${_getAmountSelected(index)}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (!_isSelected(index)) {
                                        _addSelection(index);
                                      } else {
                                        _increaseAmount(index);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.keyboard_arrow_right,
                                      size: 32,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () => _isSelected(index)
                                  ? _removeSelection(index)
                                  : _addSelection(index),
                              onLongPress: () => _showComponentBreakdown(
                                _userComponents[index],
                              ),
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
