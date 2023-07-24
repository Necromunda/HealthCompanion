import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/models/daily_data_model.dart';
import 'package:health_companion/screens/add_existing_component_screen.dart';
import 'package:health_companion/widgets/bundle_button_bar.dart';
import 'package:health_companion/widgets/bundles.dart';
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
    _userDailyDataDocStream = FirebaseFirestore.instance
        .collection("user_daily_data")
        .doc(_currentUser.uid)
        .snapshots();
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
    if (component != null) {
      _addComponentToBundle(_currentData, _currentBundleIndex, [component]);
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
    if (selectedComponents != null) {
      _addComponentToBundle(
          _currentData, _currentBundleIndex, selectedComponents);
    }
    print("Current data is $_currentData");
    print("Selected components: $selectedComponents");
  }

  void _addComponentToBundle(List<DailyData> bundles, int bundleIndex,
      List<Component> newComponents) async {
    print("bundles: $bundles");
    print("bundleindex: $bundleIndex");
    bundles[bundleIndex].components!.addAll(newComponents);
    await FirebaseService.updateDailyData(bundles);
    // DailyData newDailyData = DailyData.fromJson({
    //   "creationDate": DateTime.now().millisecondsSinceEpoch,
    //   "lastEdited": DateTime.now().millisecondsSinceEpoch,
    //   "components": components.map((e) => e.toJson()).toList(),
    //   // "components": components,
    // });
    // List<DailyData> updatedDailyData = [];

    // if (_currentData.isEmpty) {
    //   updatedDailyData.add(newDailyData);
    // } else {
    //   final DailyData latestDailyData = _currentData.last;
    //   final DateTime latestDailyDataCreationDate =
    //       DateTime.fromMillisecondsSinceEpoch(latestDailyData.creationDate!);
    //
    //   bool isNextDay = Util.isNextDay(
    //       now: DateTime.now(), compareTo: latestDailyDataCreationDate);
    //
    //   if (isNextDay) {
    //     updatedDailyData.add(newDailyData);
    //   } else {
    //     latestDailyData.components?.addAll(components);
    //     latestDailyData.lastEdited = DateTime.now().millisecondsSinceEpoch;
    //     _currentData.removeLast();
    //     _currentData.add(latestDailyData);
    //     updatedDailyData = _currentData;
    //   }
    // }
    // await FirebaseService.updateDailyData(updatedDailyData);
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

  // void _onPageChanged(int pageIndex) {
  //   // setState(() {
  //     _currentBundleIndex = pageIndex;
  //   // });
  // }

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
    // if ((_currentBundleIndex - index) < 0) {
    //   index = 0;
    // } else if ((_currentBundleIndex + index) > _lastBundleIndex) {
    //   index = _lastBundleIndex;
    // } else {
    //   index = _currentBundleIndex - index;
    // }
    print("Scroll to $index");
    // setState(() {
    _bundlePageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    // _currentBundleIndex = index;
    // });
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

  void _deleteComponentFromBundle(
      List<DailyData> bundles, int bundleIndex, int componentIndex) async {
    bundles[bundleIndex].lastEdited = DateTime.now().millisecondsSinceEpoch;
    Component? retVal =
        bundles[bundleIndex].components?.removeAt(componentIndex);
    print("Removed component: $retVal");
    await FirebaseService.updateDailyData(bundles);
  }

  void _deleteBundle() async {
    List<DailyData> updatedBundles = List.from(_currentData);
    updatedBundles.removeAt(_currentBundleIndex);
    await FirebaseService.updateDailyData(updatedBundles);
  }

  // @override
  // void didChangeDependencies() {
  //
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //
  //     if (_bundlePageViewController.hasClients) {
  //       _bundlePageViewController.jumpToPage(_lastBundleIndex);
  //     }
  //
  //   });
  //
  //   super.didChangeDependencies();
  // }

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
                      _currentData =
                          data.map((e) => DailyData.fromJson(e)).toList();

                      if (_currentData.isEmpty) {
                        _addNewBundle();
                      }
                      _lastBundleIndex = _currentData.length - 1;
                      // _bundlePageViewController =
                      //     PageController(initialPage: _lastBundleIndex);
                      // _currentBundleIndex = _lastBundleIndex;

                      // return Bundles(
                      //     key: Key("${Random().nextDouble()}"),
                      //     initialPageIndex: _lastBundleIndex,
                      //     bundles: _currentData,
                      //   onPageChanged: _onPageChanged,
                      // );
                      return PageView.builder(
                        controller: _bundlePageViewController,
                        scrollDirection: Axis.horizontal,
                        itemCount: _currentData.length,
                        onPageChanged: (index) {
                          // setState(() {
                          _currentBundleIndex = index;
                          // });
                        },
                        itemBuilder: (context, pageviewIndex) {
                          DailyData bundle = DailyData.fromJson(
                              snapshot.data["data"][pageviewIndex]);

                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                "#${pageviewIndex + 1} Bundle created: ${DateFormat('d.M H:mm').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      bundle.creationDate!),
                                )}",
                                style: const TextStyle(fontSize: 16),
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
                                      return ListTile(
                                        title: Text(
                                          bundle
                                              .components![listviewIndex].name!,
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        subtitle: Text(
                                          bundle.components?[listviewIndex]
                                                  .description ??
                                              "No description",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () =>
                                                  _deleteComponentFromBundle(
                                                      _currentData,
                                                      pageviewIndex,
                                                      listviewIndex),
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
                                            bundle.components![listviewIndex]),
                                      );
                                    },
                                  ),
                                ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                      onPressed: _showFirstBundle,
                                      icon: const Icon(
                                          Icons.keyboard_double_arrow_left)),
                                  IconButton(
                                      onPressed: _showPreviousBundle,
                                      icon: const Icon(Icons.keyboard_arrow_left)),
                                  IconButton(
                                      onPressed: _addNewBundle,
                                      icon: const Icon(Icons.add)),
                                  IconButton(
                                      onPressed: _deleteBundle,
                                      icon: const Icon(Icons.delete_forever)),
                                  IconButton(
                                      onPressed: _showNextBundle,
                                      icon: const Icon(Icons.keyboard_arrow_right)),
                                  IconButton(
                                      onPressed: _showLastBundle,
                                      icon: const Icon(
                                          Icons.keyboard_double_arrow_right)),
                                ],
                              )
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
            child: BundleButtonBar(
              onPressedLeft: _showPreviousBundle,
              onPressedCenter: _addNewBundle,
              onPressedRight: _showNextBundle,
            ),
          ),
        ],
      ),
    );
  }
}
