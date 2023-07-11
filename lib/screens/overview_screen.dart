import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/widgets/chart.dart';
import 'package:intl/intl.dart';

class Overview extends StatefulWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Chart(),
            FilledButton(onPressed: () {
              setState(() {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).popUntil(ModalRoute.withName("/"));
              });
            }, child: Text("Log out")),
          ],
        ),
      ),
    );
  }
}
