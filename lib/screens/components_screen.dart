import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/screens/add_new_component_screen.dart';
import 'package:health_companion/services/firebase_service.dart';

import '../models/appuser_model.dart';
import '../models/component_model.dart';
import 'component_breakdown_screen.dart';

class Components extends StatefulWidget {
  const Components({Key? key}) : super(key: key);

  @override
  State<Components> createState() => _ComponentsState();
}

class _ComponentsState extends State<Components> {
  final ScrollController _listScrollController = ScrollController();
  late final User _currentUser;
  late final Stream _userComponentsDocStream;

  @override
  void initState() {
    print("Components screen init");
    _currentUser = FirebaseAuth.instance.currentUser!;
    _userComponentsDocStream =
        FirebaseFirestore.instance.collection("user_components").doc(_currentUser.uid).snapshots();
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
    super.dispose();
  }

  void _addComponent() async {
    Component? component = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const AddNewComponent();
        },
      ),
    );
    if (component != null) {
      FirebaseService.saveUserComponents(_currentUser.uid, component).then((value) {
        setState(() {
          print(value);
        });
      });
    }
    print(component);
  }

  void _deleteComponent(List<Component> components, Component componentToRemove) async {
    components.removeWhere((element) => element == componentToRemove);
    FirebaseService.deleteUserComponent(_currentUser.uid, components)
        .then((value) => print("Deleted items?: $value"));
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        // mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: double.infinity,
            child: Card(
              elevation: 5,
              child: ListTile(
                title: const Text(
                  "Add component +",
                  style: TextStyle(fontSize: 22),
                ),
                trailing: const Icon(Icons.launch),
                onTap: _addComponent,
              ),
            ),
          ),
          StreamBuilder(
            stream: _userComponentsDocStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Your components could not be displayed"),
                );
              }
              if (snapshot.hasData) {
                List<Map<String, dynamic>> json =
                    snapshot.data["components"].cast<Map<String, dynamic>>();
                List<Component> components = json.map((e) => Component.fromJson(e)).toList();
                // setState(() {
                //   _userComponents = json.map((e) => Component.fromJson(e)).toList();
                // });
                // print(snapshot.data["components"]);
                // if (_userComponents.isNotEmpty) {
                return Expanded(
                  child: Card(
                    elevation: 5,
                    child: components.isEmpty
                        ? const Center(
                            child: Text(
                              "You have no components",
                              style: TextStyle(fontSize: 22),
                            ),
                          )
                        : ListView.builder(
                            controller: _listScrollController,
                            itemCount: components.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  components[index].name!,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                subtitle: Text(
                                  components[index].description!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          _deleteComponent(components, components[index]),
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 32.0,
                                      ),
                                    ),
                                    const Icon(Icons.launch)
                                  ],
                                ),
                                onTap: () => _showComponentBreakdown(components[index]),
                              );
                            },
                          ),
                  ),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("Error getting your components"),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
