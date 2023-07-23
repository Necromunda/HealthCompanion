import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/models/daily_data_model.dart';
import 'package:health_companion/screens/add_existing_component_screen.dart';
import 'package:health_companion/widgets/bundle_button_bar.dart';
import 'package:health_companion/widgets/chart.dart';
import 'package:health_companion/widgets/custom_button.dart';
import 'package:health_companion/widgets/loading_components.dart';
import 'package:intl/intl.dart';

import '../models/appuser_model.dart';
import '../models/component_model.dart';
import '../services/firebase_service.dart';
import '../util.dart';
import 'add_new_component_screen.dart';
import 'component_breakdown_screen.dart';

class Overview extends StatefulWidget {
  // final AppUser user;

  // const Overview({Key? key, required this.user}) : super(key: key);
  const Overview({Key? key}) : super(key: key);

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  late final ScrollController _scrollController, _listScrollController;
  late final User _currentUser;
  late final Stream _userDailyDataDocStream;
  late String _today;
  late List<DailyData> _currentData;
  late bool _isLatestDataCurrentDaysData;
  late int _currentBundleIndex, _lastBundleIndex;
  late PageController _bundlePageViewController;

  @override
  void initState() {
    print("Overview screen init");
    _currentUser = FirebaseAuth.instance.currentUser!;
    _scrollController = ScrollController();
    _listScrollController = ScrollController();
    _bundlePageViewController = PageController();
    _currentBundleIndex = 0;
    _lastBundleIndex = 0;
    _userDailyDataDocStream =
        FirebaseFirestore.instance.collection("user_daily_data").doc(_currentUser.uid).snapshots();
    _today = DateFormat('EEEE').format(DateTime.now());
    _currentData = [];
    // _isLatestDataCurrentDaysData = true;
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  // @override
  // void didUpdateWidget(covariant Overview oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  // }

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
    if (component != null) _addComponentToDailyData(<Component>[component]);
    print(component);
  }

  void _addExistingComponentButtonHandler() async {
    final List<Component>? selectedComponents = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddExistingComponent(),
      ),
    );
    if (selectedComponents != null) {
      _addComponentToDailyData(selectedComponents);
    }
    print("Current data is $_currentData");
    print("Selected components: $selectedComponents");
  }

  void _addNewBundle() async {
    print(_currentBundleIndex);
    DailyData newBundle = DailyData.fromJson({
      "creationDate": DateTime.now().millisecondsSinceEpoch,
      "lastEdited": DateTime.now().millisecondsSinceEpoch,
      "components": [],
    });
    _currentData.add(newBundle);
    await FirebaseService.updateDailyData(_currentData);
    _scrollBundles(_lastBundleIndex);
  }

  void _showPreviousBundle() {
    if (_currentBundleIndex > 0) {
      // setState(() {
      _currentBundleIndex -= 1;
      _scrollBundles(_currentBundleIndex);
      // });
    }
    // print(
    //     "CURRENT INDEX: $_currentBundleIndex\nLAST BUNDLE INDEX: $_lastBundleIndex\nNUMBER OF BUNDLES: ${_currentData.length}");
  }

  void _showNextBundle() {

    if (_currentBundleIndex < _lastBundleIndex) {
      // setState(() {
      _currentBundleIndex += 1;
      _scrollBundles(_currentBundleIndex);
      // });
    }
    // print(
    //     "CURRENT INDEX: $_currentBundleIndex\nLAST BUNDLE INDEX: $_lastBundleIndex\nNUMBER OF BUNDLES: ${_currentData.length}");
  }

  void _scrollBundles(int index) {
    // print("Scroll to $index");
    // print("Current data length ${_currentData.length}");
    _bundlePageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _addComponentToDailyData(List<Component> components) async {
    DailyData newDailyData = DailyData.fromJson({
      "creationDate": DateTime.now().millisecondsSinceEpoch,
      "lastEdited": DateTime.now().millisecondsSinceEpoch,
      "components": components.map((e) => e.toJson()).toList(),
      // "components": components,
    });
    List<DailyData> updatedDailyData = [];

    if (_currentData.isEmpty) {
      updatedDailyData.add(newDailyData);
    } else {
      final DailyData latestDailyData = _currentData.last;
      final DateTime latestDailyDataCreationDate =
          DateTime.fromMillisecondsSinceEpoch(latestDailyData.creationDate!);

      bool isNextDay = Util.isNextDay(now: DateTime.now(), compareTo: latestDailyDataCreationDate);

      if (isNextDay) {
        updatedDailyData.add(newDailyData);
      } else {
        latestDailyData.components?.addAll(components);
        latestDailyData.lastEdited = DateTime.now().millisecondsSinceEpoch;
        _currentData.removeLast();
        _currentData.add(latestDailyData);
        updatedDailyData = _currentData;
      }
    }
    await FirebaseService.updateDailyData(updatedDailyData);
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

  void _deleteComponentFromDailyData(DailyData todaysData, int componentIndex) async {
    todaysData.lastEdited = DateTime.now().millisecondsSinceEpoch;
    Component? retVal = todaysData.components?.removeAt(componentIndex);
    _currentData.removeLast();
    _currentData.add(todaysData);
    print("Removed component: $retVal");
    await FirebaseService.updateDailyData(_currentData);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          const Chart(),
          Card(
            elevation: 3,
            child: ExpansionTile(
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
                  trailing: const Icon(Icons.launch),
                  onTap: _addNewComponentButtonHandler,
                ),
                ListTile(
                  title: const Text(
                    "Add existing component",
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: const Icon(Icons.launch),
                  onTap: _addExistingComponentButtonHandler,
                ),
              ],
            ),
          ),

          // Bug in pageview: When deleting bundle from db, pageview doesnt update so current index is wrong.

          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 3,
                child: StreamBuilder(
                  stream: _userDailyDataDocStream,
                  builder: (context, snapshot) {
                    if (snapshot.data?.data() == null) {
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
                      _currentData = data.map((e) => DailyData.fromJson(e)).toList();
                      print(_currentData);
                      if (_currentData.isEmpty) {
                        _addNewBundle();
                      } else {
                        _lastBundleIndex = _currentData.length - 1;
                        print("LASTBUNDLEINDEX: $_lastBundleIndex");
                        _bundlePageViewController = PageController(initialPage: _lastBundleIndex);
                        print("INIT PAGE: ${_bundlePageViewController.initialPage}");
                        _currentBundleIndex = _lastBundleIndex;
                        print("CURRENTBUNDLEINDEX: $_lastBundleIndex");

                        DailyData latestDailyData = _currentData.last;
                        final DateTime latestDailyDataCreationDate =
                            DateTime.fromMillisecondsSinceEpoch(latestDailyData.creationDate!);
                        final DateTime latestDailyDataEditedDate =
                            DateTime.fromMillisecondsSinceEpoch(latestDailyData.lastEdited!);
                        final String formattedCreatedDate =
                            DateFormat('d.M H:mm').format(latestDailyDataCreationDate);
                        final String formattedEditedDate =
                            DateFormat('d.M H:mm').format(latestDailyDataEditedDate);

                        print("LATEST DATA CREATED: $latestDailyDataCreationDate");
                        print("LATEST DATA EDITED: $latestDailyDataEditedDate");
                        // if (_currentData.last.components!.isEmpty) {
                        if (false) {
                          return SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                "No data in this bundle\nCreated $formattedCreatedDate",
                                style: const TextStyle(fontSize: 22),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }

                        return SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(
                                  "What you have eaten",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Expanded(
                                child: PageView.builder(
                                  controller: _bundlePageViewController,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _currentData.length,
                                  onPageChanged: (index) {
                                    _currentBundleIndex = index;
                                  },
                                  itemBuilder: (context, index) {
                                    return Center(
                                      child: Text("Bundle $index"),
                                    );
                                  },
                                ),
                              )
                              // Expanded(
                              //   child: ListView.builder(
                              //     padding: EdgeInsets.zero,
                              //     controller: _listScrollController,
                              //     itemCount: latestDailyData.components!.length,
                              //     // itemCount: 10,
                              //     // shrinkWrap: true,
                              //     itemBuilder: (context, index) {
                              //       return ListTile(
                              //         title: Text(
                              //           latestDailyData.components![index].name ?? "No name",
                              //           // "Item $index",
                              //           style: const TextStyle(
                              //             fontSize: 18,
                              //           ),
                              //         ),
                              //         subtitle: Text(
                              //           latestDailyData.components![index].description ??
                              //               "No description",
                              //           // "Item $index description",
                              //           style: const TextStyle(fontSize: 16),
                              //         ),
                              //         trailing: Row(
                              //           mainAxisSize: MainAxisSize.min,
                              //           children: [
                              //             IconButton(
                              //               onPressed: () => _deleteComponentFromDailyData(
                              //                   latestDailyData, index),
                              //               icon: const Icon(
                              //                 Icons.delete,
                              //                 color: Colors.red,
                              //                 size: 32.0,
                              //               ),
                              //             ),
                              //             const Icon(Icons.launch)
                              //           ],
                              //         ),
                              //         onTap: () => _showComponentBreakdown(
                              //             latestDailyData.components![index]),
                              //       );
                              //     },
                              //   ),
                              // ),
                            ],
                          ),
                        );
                      }
                    }
                    return const LoadingComponents();
                  },
                ),
              ),
            ),
          ),
          BundleButtonBar(
            onPressedLeft: _showPreviousBundle,
            onPressedCenter: _addNewBundle,
            onPressedRight: _showNextBundle,
          ),
        ],
      ),
    );
  }
}
