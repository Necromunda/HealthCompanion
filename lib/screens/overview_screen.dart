import 'dart:ffi';

import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/widgets/chart.dart';
import 'package:intl/intl.dart';

class Overview extends StatefulWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview>
    with AutomaticKeepAliveClientMixin<Overview> {
  final ScrollController _scrollController = ScrollController();

  // final ExpandableController _expandableController = ExpandableController();
  // final ExpansionTileController controller = ExpansionTileController();

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
    // _expandableController.dispose();
    super.dispose();
  }

  void _addNewComponentButtonHandler() {}

  void _addExistingComponentButtonHandler() {}

  @override
  Widget build(BuildContext context) {
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
            FilledButton(
                onPressed: () {
                  setState(() {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).popUntil(ModalRoute.withName("/"));
                  });
                },
                child: const Text("Log out")),
          ],
        ),
      ),
    );
  }
}
