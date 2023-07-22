import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/models/daily_data_model.dart';
import 'package:health_companion/screens/add_existing_component_screen.dart';
import 'package:health_companion/widgets/chart.dart';
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

  // late List<Map<String, dynamic>> _currentData;
  late List<DailyData> _currentData;
  late bool _isLatestDataCurrentDaysData;

  @override
  void initState() {
    print("Overview screen init");
    _currentUser = FirebaseAuth.instance.currentUser!;
    _scrollController = ScrollController();
    _listScrollController = ScrollController();
    _userDailyDataDocStream =
        FirebaseFirestore.instance.collection("user_daily_data").doc(_currentUser.uid).snapshots();
    _today = DateFormat('EEEE').format(DateTime.now());
    _currentData = [];
    _isLatestDataCurrentDaysData = true;
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
    // if (component != null) await FirebaseService.saveUserComponents(_currentUser.uid, component);
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
    // await userDailyDataDocRef.update({"data": updatedDailyData});
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
      // child: SingleChildScrollView(
      //   controller: _scrollController,
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
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 3,
                child: StreamBuilder(
                  stream: _userDailyDataDocStream,
                  builder: (context, snapshot) {
                    if (snapshot.data?.data() != null) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Your components could not be displayed"),
                        );
                      }
                      if (snapshot.hasData) {
                        List<Map<String, dynamic>> data =
                        snapshot.data["data"].cast<Map<String, dynamic>>();
                        _currentData = data.map((e) => DailyData.fromJson(e)).toList();
                        if (_currentData.isEmpty || _currentData.last.components!.isEmpty || !_isLatestDataCurrentDaysData) {
                          return SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                "No data found for ${_today.toLowerCase()}",
                                style: const TextStyle(fontSize: 22),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        } else {
                          // Map<String, dynamic> latestData = data.last;
                          DailyData latestDailyData = _currentData.last;
                          // DailyData latestDailyData = DailyData.fromJson(latestData);
                          final DateTime latestDailyDataCreationDate =
                          DateTime.fromMillisecondsSinceEpoch(latestDailyData.creationDate!);
                          // final DateTime latestDailyDataCreationDate = DateTime.now().add(const Duration(hours: -25));

                          print("LATEST DATA CREATED: $latestDailyDataCreationDate");
                          print("LATEST DATA EDITED: ${DateTime.fromMillisecondsSinceEpoch(latestDailyData.lastEdited!)}");

                          bool isNextDay = Util.isNextDay(
                              now: DateTime.now(), compareTo: latestDailyDataCreationDate);
                          if (isNextDay) {
                            Future(
                                  () => setState(
                                    () {
                                  _isLatestDataCurrentDaysData = false;
                                },
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
                                    "What you have eaten today",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    controller: _listScrollController,
                                    itemCount: latestDailyData.components!.length,
                                    // itemCount: 10,
                                    // shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                          latestDailyData.components![index].name ?? "No name",
                                          // "Item $index",
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        subtitle: Text(
                                          latestDailyData.components![index].description ??
                                              "No description",
                                          // "Item $index description",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () =>
                                                  _deleteComponentFromDailyData(latestDailyData, index),
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
                                            latestDailyData.components![index]),
                                        // shape: const Border(top: BorderSide()),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return const Center(
                      child: Text("Loading your data"),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
