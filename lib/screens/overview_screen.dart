import 'dart:ffi';

import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/widgets/chart.dart';
import 'package:intl/intl.dart';

import '../models/component_model.dart';
import 'add_component_screen.dart';

class Overview extends StatefulWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> with AutomaticKeepAliveClientMixin<Overview> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _listScrollController = ScrollController();
  List<Component> _consumedComponents = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didUpdateWidget(covariant Overview oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _addNewComponentButtonHandler() async {
    Component? _component = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const AddComponent();
        },
      ),
    );
    print(_component);
  }

  void _addExistingComponentButtonHandler() {}

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            const Chart(),
            Card(
              elevation: 5,
              child: ExpansionTile(
                // trailing: SizedBox.shrink(),
                // iconColor: Colors.green,
                // controlAffinity: null,
                title: const Text(
                  "Add component +",
                  style: TextStyle(fontSize: 22),
                  // textAlign: TextAlign.center,
                ),
                children: [
                  ListTile(
                    title: const Text(
                      "Add new component",
                      style: TextStyle(fontSize: 18),
                      // textAlign: TextAlign.center,
                    ),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: _addNewComponentButtonHandler,
                  ),
                  ListTile(
                    title: const Text(
                      "Add existing component",
                      style: TextStyle(fontSize: 18),
                      // textAlign: TextAlign.center,
                    ),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: _addExistingComponentButtonHandler,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 5,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        "What you've eaten today",
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                    ListView.builder(
                      controller: _listScrollController,
                      // itemCount: _consumedComponents.length,
                      itemCount: 11,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return (_consumedComponents.isEmpty)
                            ? ListTile(
                                title: Text(
                                  "Item $index",
                                  style: const TextStyle(fontSize: 18),
                                ),
                                subtitle: Text(
                                  "Item $index description",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                trailing: const Icon(Icons.arrow_forward),
                                onTap: null,
                              )
                            : ListTile(
                                title: Text(
                                  _consumedComponents[index].name!,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                subtitle: Text(
                                  _consumedComponents[index].description!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                trailing: const Icon(Icons.arrow_forward),
                                onTap: null,
                              );
                      },
                    )
                  ],
                ),
              ),
            ),
            Row(
              children: [
                FilledButton(
                  onPressed: () {
                    setState(() {
                      FirebaseAuth.instance.signOut().then((value) {
                        Navigator.of(context).popUntil(ModalRoute.withName("/"));
                      }).catchError((_) {
                        print("Error logging out");
                      });
                    });
                  },
                  child: const Text("Log out"),
                ),
                FilledButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text("Update"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
