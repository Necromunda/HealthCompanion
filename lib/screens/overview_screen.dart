import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/models/bundle_model.dart';
import 'package:health_companion/models/user_preferences_model.dart';
import 'package:health_companion/screens/add_existing_component_screen.dart';
import 'package:health_companion/widgets/chart.dart';
import 'package:health_companion/widgets/loading_components.dart';
import 'package:intl/intl.dart';

import '../models/component_model.dart';
import '../services/firebase_service.dart';
import 'add_new_component_screen.dart';
import 'component_breakdown_screen.dart';

class Overview extends StatefulWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  late final ScrollController _scrollController, _listScrollController;
  late final User _currentUser;
  late final Stream _userDailyDataDocStream;
  late List<Bundle> _userBundles;
  late int _currentBundleIndex, _lastBundleIndex;
  late PageController _bundlePageViewController;
  UserPreferences? _userPreferences;

  @override
  void initState() {
    print("Overview screen init");
    _currentUser = FirebaseAuth.instance.currentUser!;
    _scrollController = ScrollController();
    _listScrollController = ScrollController();
    _bundlePageViewController = PageController();
    _currentBundleIndex = 0;
    _lastBundleIndex = 0;
    _userBundles = [];
    _userDailyDataDocStream = FirebaseFirestore.instance
        .collection("user_daily_data")
        .doc(_currentUser.uid)
        .snapshots();
    print(_userPreferences);
    userPreferences.then((value) => setState(() {
          _userPreferences = value;
          print(_userPreferences);
    }));
    // _userPreferences = UserPreferences();
    super.initState();
  }

  Future<UserPreferences> get userPreferences async {
    final json = await FirebaseService.getUserPreferences();
    if (json == null) {
      return UserPreferences();
    }
    return UserPreferences.fromJson(json);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _listScrollController.dispose();
    _bundlePageViewController.dispose();
    super.dispose();
  }

  void _addNewComponentButtonHandler() async {
    Component? component = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const AddNewComponent();
        },
      ),
    );
    if (component != null) {
      _addComponentToBundle(_userBundles, _currentBundleIndex, [component]);
    }
    print(component);
  }

  void _addExistingComponentButtonHandler() async {
    final List<Component>? selectedComponents =
        await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddExistingComponent(),
      ),
    );
    if (selectedComponents != null && selectedComponents.isNotEmpty) {
      _addComponentToBundle(
          _userBundles, _currentBundleIndex, selectedComponents);
    }
    print("Current data is $_userBundles");
    print("Selected components: $selectedComponents");
  }

  void _addComponentToBundle(List<Bundle> bundles, int bundleIndex,
      List<Component> newComponents) async {
    print("bundles: $bundles");
    print("bundleindex: $bundleIndex");
    // bundles[bundleIndex].lastEdited = DateTime.now().millisecondsSinceEpoch;
    bundles[bundleIndex].lastEdited = DateTime.now();
    bundles[bundleIndex].components!.addAll(newComponents);
    await FirebaseService.updateDailyData(bundles);
  }

  void _addNewBundle() async {
    print(_currentBundleIndex);
    Bundle newBundle = Bundle.fromJson({
      // "creationDate": DateTime.now().millisecondsSinceEpoch,
      "creationDate": DateTime.now(),
      // "lastEdited": DateTime.now().millisecondsSinceEpoch,
      "lastEdited": DateTime.now(),
      "components": [],
    });
    _userBundles.add(newBundle);
    await FirebaseService.updateDailyData(_userBundles);
    await FirebaseService.addToStats(UserStats.addBundle, 1);
    _scrollBundles(_lastBundleIndex);
  }

  void _deleteComponentFromBundle(
      List<Bundle> bundles, int bundleIndex, int componentIndex) async {
    // bundles[bundleIndex].lastEdited = DateTime.now().millisecondsSinceEpoch;
    bundles[bundleIndex].lastEdited = DateTime.now();
    Component? retVal =
        bundles[bundleIndex].components?.removeAt(componentIndex);
    print("Removed component: $retVal");
    await FirebaseService.updateDailyData(bundles);
  }

  void _deleteBundle(int bundleIndex) async {
    List<Bundle> updatedBundles = List.from(_userBundles);
    if (bundleIndex == 0) {
      if (updatedBundles.length > 1) {
        updatedBundles.removeAt(0);
      } else {
        updatedBundles[0] = Bundle.fromJson({
          // "creationDate": DateTime.now().millisecondsSinceEpoch,
          "creationDate": DateTime.now(),
          // "lastEdited": DateTime.now().millisecondsSinceEpoch,
          "lastEdited": DateTime.now(),
          "components": [],
        });
      }
    } else {
      updatedBundles.removeAt(_currentBundleIndex);
      if (bundleIndex == _lastBundleIndex) {
        _currentBundleIndex -= 1;
      }
    }
    await FirebaseService.updateDailyData(updatedBundles);
    await FirebaseService.addToStats(UserStats.deleteBundle, 1);
  }

  void _showPreviousBundle() {
    if (_currentBundleIndex > 0) {
      _currentBundleIndex -= 1;
      _scrollBundles(_currentBundleIndex);
    }
  }

  void _showNextBundle() {
    if (_currentBundleIndex < _lastBundleIndex) {
      _currentBundleIndex += 1;
      _scrollBundles(_currentBundleIndex);
    }
  }

  void _showFirstBundle() {
    _currentBundleIndex = 0;
    _scrollBundles(_currentBundleIndex);
  }

  void _showLastBundle() {
    _currentBundleIndex = _lastBundleIndex;
    _scrollBundles(_currentBundleIndex);
  }

  void _scrollBundles(int index) {
    print("Scroll to $index");
    // _bundlePageViewController.animateToPage(
    _bundlePageViewController.jumpToPage(
      index,
      // duration: const Duration(milliseconds: 300),
      // curve: Curves.easeInOut,
    );
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
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            elevation: 3,
            child: ExpansionTile(
              shape: Border.all(color: Colors.transparent),
              title: const Text(
                "Add component +",
                style: TextStyle(fontSize: 22),
              ),
              children: [
                ListTile(
                  title: const Text(
                    "Add new component",
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: _addNewComponentButtonHandler,
                ),
                const Divider(
                  height: 0,
                  indent: 10,
                  endIndent: 10,
                  color: Colors.black,
                ),
                ListTile(
                  title: const Text(
                    "Add existing component",
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: _addExistingComponentButtonHandler,
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 3,
                child: StreamBuilder(
                  stream: _userDailyDataDocStream,
                  builder: (context, snapshot) {
                    if (snapshot.data?.data() == null) {
                      print("here");
                      return const LoadingComponents(
                        message: "Loading your data",
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Your components could not be displayed"),
                      );
                    }
                    if (snapshot.hasData) {
                      List<Map<String, dynamic>> data =
                          snapshot.data["data"].cast<Map<String, dynamic>>();
                      _userBundles =
                          data.map((e) => Bundle.fromJson(e)).toList();

                      if (_userBundles.isEmpty) {
                        _addNewBundle();
                      }
                      print(_userBundles);
                      _lastBundleIndex = _userBundles.length - 1;

                      return PageView.builder(
                        controller: _bundlePageViewController,
                        scrollDirection: Axis.horizontal,
                        itemCount: _userBundles.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentBundleIndex = index;
                          });
                        },
                        itemBuilder: (context, pageViewIndex) {
                          Bundle bundle = _userBundles[pageViewIndex];

                          return Column(
                            // mainAxisSize: MainAxisSize.max,
                            children: [
                              if (bundle.components!.isNotEmpty)
                                Chart(
                                  // key: Key("${Random().nextDouble() * 1000}"),
                                  // key: Key("${bundle.components?.length}"),
                                  key: UniqueKey(),
                                  bundle: bundle,
                                  userPreferences: _userPreferences,
                                ),
                              const SizedBox(height: 5),
                              Text(
                                "#${pageViewIndex + 1} Bundle created: ${DateFormat('d.M H:mm').format(bundle.creationDate!)}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Last edited: ${DateFormat('d.M H:mm').format(bundle.lastEdited!)}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 5),
                              const Divider(
                                indent: 20,
                                endIndent: 20,
                                color: Colors.black,
                                thickness: 1,
                              ),
                              if (bundle.components!.isEmpty)
                                const Expanded(
                                  child: Center(
                                    child: Text(
                                      "This bundle is empty",
                                      style: TextStyle(fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              else
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    controller: _listScrollController,
                                    itemCount: bundle.components!.length,
                                    itemBuilder: (context, listviewIndex) {
                                      // _scrollBundles(_lastBundleIndex);
                                      return Card(
                                        clipBehavior: Clip.antiAlias,
                                        child: ListTile(
                                          title: Text(
                                            bundle.components![listviewIndex]
                                                .name!,
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          subtitle: Text(
                                            bundle.components?[listviewIndex]
                                                    .description ??
                                                "No description",
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              // IconButton(
                                              //   onPressed: () =>
                                              //       _deleteComponentFromBundle(
                                              //     _userBundles,
                                              //     pageviewIndex,
                                              //     listviewIndex,
                                              //   ),
                                              //   icon: const Icon(
                                              //     Icons.delete,
                                              //     color: Colors.red,
                                              //     size: 32.0,
                                              //   ),
                                              // ),
                                              Icon(Icons.keyboard_arrow_right)
                                            ],
                                          ),
                                          onTap: () => _showComponentBreakdown(
                                            bundle.components![listviewIndex],
                                          ),
                                          onLongPress: () =>
                                              _deleteComponentFromBundle(
                                            _userBundles,
                                            pageViewIndex,
                                            listviewIndex,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          );
                        },
                      );
                    }
                    return const LoadingComponents();
                  },
                ),
              ),
            ),
          ),
          Card(
            elevation: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: _showFirstBundle,
                  icon: const Icon(Icons.keyboard_double_arrow_left),
                ),
                IconButton(
                  onPressed: _showPreviousBundle,
                  icon: const Icon(Icons.keyboard_arrow_left),
                ),
                IconButton(
                  onPressed: _addNewBundle,
                  icon: const Icon(Icons.add),
                ),
                IconButton(
                  onPressed: () => _deleteBundle(_currentBundleIndex),
                  icon: const Icon(Icons.delete_forever),
                ),
                IconButton(
                  onPressed: _showNextBundle,
                  icon: const Icon(Icons.keyboard_arrow_right),
                ),
                IconButton(
                  onPressed: _showLastBundle,
                  icon: const Icon(Icons.keyboard_double_arrow_right),
                ),
              ],
            ),
          ),
          // Card(
          //   child: BundleButtonBar(
          //     onPressedLeft: _showPreviousBundle,
          //     onPressedCenter: _addNewBundle,
          //     onPressedRight: _showNextBundle,
          //   ),
          // ),
        ],
      ),
    );
  }
}
