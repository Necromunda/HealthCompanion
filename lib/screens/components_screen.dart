import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/screens/add_new_component_screen.dart';
import 'package:health_companion/services/firebase_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/component_model.dart';
import '../util.dart';
import '../widgets/loading_components.dart';
import '../widgets/no_components_found.dart';
import 'component_breakdown_screen.dart';
import 'edit_component_screen.dart';

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
  late List<Component> _userComponents, _searchResults;

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
    _userComponents = [];
    _searchResults = [];
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
      // await FirebaseService.saveUserComponents(_currentUser.uid, component);
      await FirebaseService.saveUserComponents(component);
      await FirebaseService.addToStats(UserStats.addComponent, 1);
      if (_searchString.isNotEmpty) {
        if (component.name!.toLowerCase().contains(_searchString)) {
          setState(() {
            _searchResults.add(component);
          });
        }
      }
    }
    _addComponentAchievement();
    print(component);
  }

  void _addComponentAchievement() {
    if (_userComponents.length >= 250) {
      FirebaseService.addAchievement(
          context, UserAchievementType.components250);
    } else if (_userComponents.length >= 100) {
      FirebaseService.addAchievement(
          context, UserAchievementType.components100);
    } else if (_userComponents.length >= 50) {
      FirebaseService.addAchievement(context, UserAchievementType.components50);
    } else if (_userComponents.length >= 10) {
      FirebaseService.addAchievement(context, UserAchievementType.components10);
    }
  }

  void _deleteComponent(Component component) async {
    List<Component> duplicates =
        _userComponents.where((element) => element == component).toList();
    if (duplicates.length == 1) {
      _userComponents.removeWhere((element) => element == component);
      if (_searchResults.isNotEmpty) {
        _searchResults.removeWhere((element) => element == component);
      }
    } else {
      _userComponents.remove(component);
      if (_searchResults.isNotEmpty) {
        _searchResults.remove(component);
      }
    }
    await FirebaseService.deleteUserComponent(_userComponents);
    await FirebaseService.addToStats(UserStats.deleteComponent, 1);
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

  void _onSearchTextChanged(String text) async {
    _searchString = text;
    _searchResults.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userComponents.forEach((component) {
      if (component.name!.toLowerCase().contains(text.toLowerCase())) {
        _searchResults.add(component);
      }
    });

    print(_searchResults);
    setState(() {});
  }

  void _editComponent(Component component) async {
    Component? updatedComponent = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditComponent(component: component),
      ),
    );
    if (updatedComponent != null) {
      await FirebaseService.updateUserComponents(updatedComponent);
    }
  }

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
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: _addComponent,
              ),
            ),
          ),
          // const SizedBox(height: 10,),
          // _searchTextField,
          const SizedBox(
            height: 10,
          ),
          _searchTextField,
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
                  _userComponents = List.from(components);

                  if (components.isEmpty) {
                    return const NoComponentsFound();
                  } else {
                    if (_searchString.isNotEmpty && _searchResults.isEmpty) {
                      return const Center(
                        child: Text("No matches"),
                      );
                    } else {
                      return _searchResults.isNotEmpty
                          ? ListView.builder(
                              padding: EdgeInsets.zero,
                              controller: _listScrollController,
                              itemCount: _searchResults.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  child: ListTile(
                                    title: Text(
                                      _searchResults[index].name!,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    subtitle: Text(
                                      _searchResults[index].description!,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () =>
                                              _editComponent(components[index]),
                                          icon: const Icon(
                                            Icons.edit,
                                            // color: Colors.white,
                                            size: 32.0,
                                          ),
                                        ),
                                        const Icon(Icons.keyboard_arrow_right)
                                      ],
                                    ),
                                    onTap: () => _showComponentBreakdown(
                                      _searchResults[index],
                                    ),
                                    onLongPress: () =>
                                        _deleteComponent(_searchResults[index]),
                                  ),
                                );
                              },
                            )
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              controller: _listScrollController,
                              itemCount: components.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Card(
                                  clipBehavior: Clip.antiAlias,
                                  margin: const EdgeInsets.only(bottom: 4),
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
                                              _editComponent(components[index]),
                                          icon: const Icon(
                                            Icons.edit,
                                            // color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                        const Icon(Icons.keyboard_arrow_right)
                                      ],
                                    ),
                                    onTap: () => _showComponentBreakdown(
                                        components[index]),
                                    onLongPress: () =>
                                        _deleteComponent(components[index]),
                                  ),
                                );
                              },
                            );
                    }
                  }
                }
                return const LoadingComponents();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget get _searchTextField => Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: TextField(
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          controller: _searchController,
          keyboardType: TextInputType.text,
          maxLength: 99,
          onChanged: (value) => _onSearchTextChanged(value),
          style: TextStyle(
            color: Util.isDark(context) ? Colors.white : Colors.black,
          ),
          decoration: InputDecoration(
            counterText: "",
            hintText: "Search",
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            filled: true,
            // fillColor: const Color(0XDEDEDEDE),
            fillColor: Theme.of(context).colorScheme.secondaryContainer,
            // fillColor: Theme.of(context).cardColor.withOpacity(0),
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
                    // color: const Color(0XDEDEDEDE).withOpacity(1),
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    spreadRadius: 0,
                    offset: const Offset(1, 0), // changes position of shadow
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.search, size: 30),
              ),
            ),
          ),
        ),
      );
}
