import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/screens/add_new_component_screen.dart';
import 'package:health_companion/services/firebase_service.dart';

import '../models/appuser_model.dart';
import '../models/component_model.dart';
import '../widgets/loading_components.dart';
import '../widgets/no_components_found.dart';
import 'component_breakdown_screen.dart';

class Components extends StatefulWidget {
  const Components({Key? key}) : super(key: key);

  @override
  State<Components> createState() => _ComponentsState();
}

class _ComponentsState extends State<Components> {
  late final ScrollController _listScrollController;
  late final TextEditingController _searchController;
  late final User _currentUser;
  late final Stream _userComponentsDocStream;
  late String _searchString;

  @override
  void initState() {
    print("Components screen init");
    _currentUser = FirebaseAuth.instance.currentUser!;
    _userComponentsDocStream = FirebaseFirestore.instance
        .collection("user_components")
        .doc(_currentUser.uid)
        .snapshots();
    _listScrollController = ScrollController();
    _searchController = TextEditingController();
    _searchString = "";
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
    _searchController.dispose();
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
      FirebaseService.saveUserComponents(_currentUser.uid, component);
    }
    print(component);
  }

  // void _deleteComponent(List<Component> components, Component componentToRemove) async {
  void _deleteComponent(List<Component> components, int index) async {
    components.removeAt(index);
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

  Widget get _searchTextField => TextField(
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        controller: _searchController,
        keyboardType: TextInputType.text,
        maxLength: 99,
        onChanged: (value) {
          setState(() {});
        },
        decoration: InputDecoration(
          counterText: "",
          hintText: "Search",
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          filled: true,
          fillColor: const Color(0XDEDEDEDE),
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
                  color: const Color(0XDEDEDEDE).withOpacity(1),
                  spreadRadius: 0,
                  offset: const Offset(1, 0), // changes position of shadow
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.search, size: 30, color: Colors.black87),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Card(
              margin: EdgeInsets.zero,
              // elevation: 3,
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
          // const SizedBox(height: 10,),
          // _searchTextField,
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: StreamBuilder(
              // key: Key(_searchString),
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
                  List<Component> components =
                      json.map((e) => Component.fromJson(e)).toList();
                  print(components
                      .map((e) => e.name?.contains(_searchString))
                      .toList());

                  if (components.isEmpty) {
                    return const NoComponentsFound();
                  } else {
                    return Column(
                      children: [
                        _searchTextField,
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.builder(
                            // key: Key(_searchString),
                            padding: EdgeInsets.zero,
                            controller: _listScrollController,
                            itemCount: _searchString.isEmpty
                                ? components.length
                                : components
                                    .map((e) => e.name?.contains(_searchString))
                                    .toList()
                                    .length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: EdgeInsets.only(bottom: 4),
                                child: ListTile(
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
                                            _deleteComponent(components, index),
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 32.0,
                                        ),
                                      ),
                                      const Icon(Icons.launch)
                                    ],
                                  ),
                                  onTap: () => _showComponentBreakdown(
                                      components[index]),
                                  // shape: components.indexOf(components.last) == index
                                  //     ? null
                                  //     : const Border(bottom: BorderSide()),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                }
                // return const Expanded(child: LoadingComponents());
                return const LoadingComponents();
              },
            ),
          ),
        ],
      ),
    );
  }
}
