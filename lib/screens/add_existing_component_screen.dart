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
  late List<Component> _selectedComponents;
  late List<int> _selectedComponentsIndexes;
  late final ScrollController _listScrollController;
  late final Stream _userComponentsDocStream;
  late final User? _currentUser;

  @override
  void initState() {
    _currentUser = FirebaseAuth.instance.currentUser;
    _selectedComponents = <Component>[];
    _selectedComponentsIndexes = <int>[];
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
      _selectedComponents.add(component);
      _selectedComponentsIndexes.add(index);
    });
  }

  // void _removeSelection(Component component) {
  void _removeSelection(int index, Component component) {
    setState(() {
      _selectedComponents.remove(component);
      _selectedComponentsIndexes.remove(index);
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
    return _selectedComponentsIndexes.contains(index);
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
            onPressed: () => Navigator.of(context).pop(_selectedComponents),
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
                              // trailing: const Icon(Icons.keyboard_arrow_right),
                              // onTap: () => _isSelected(components[index])
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
