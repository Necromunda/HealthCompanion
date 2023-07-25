import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/widgets/chartbar.dart';
import 'package:health_companion/widgets/chartbar_horizontal.dart';
import 'package:intl/intl.dart';

import '../models/bundle_model.dart';

class Chart extends StatefulWidget {
  final Bundle bundle;

  const Chart({Key? key, required this.bundle}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  late final User _currentUser;
  late final Stream _userPreferencesDocStream;
  final ScrollController _scrollController = ScrollController();
  late final Bundle _bundle;

  @override
  void initState() {
    print("Chart screen init");
    _bundle = widget.bundle;
    _currentUser = FirebaseAuth.instance.currentUser!;
    _userPreferencesDocStream = FirebaseFirestore.instance
        .collection("user_daily_data")
        .doc(_currentUser.uid)
        .snapshots();
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // DateTime currentBundleCreated = DateTime.fromMillisecondsSinceEpoch(
    //     _bundles[_currentBundleIndex].creationDate!);
    // DateTime? nextBundleCreated = (_currentBundleIndex < _bundles.length - 1)
    //     ? DateTime.fromMillisecondsSinceEpoch(
    //         _bundles[_currentBundleIndex + 1].creationDate!)
    //     : null;

    return SizedBox(
      width: double.infinity,
      // child: Card(
      //   elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 15.0),
            //   child: Text(
            //     "Bundle created: ${DateFormat('d.M H:mm').format(
            //       DateTime.fromMillisecondsSinceEpoch(_bundle.creationDate!),
            //     )}",
            //     style: const TextStyle(fontSize: 16),
            //   ),
            // ),
            SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_bundle.totalAlcohol != 0.0)
                          SizedBox(
                            width: 75,
                            child: ChartBar(
                              label: "Alcohol",
                              value: _bundle.totalAlcohol!,
                              totalValuePct:
                                  _bundle.totalAlcohol! / _bundle.totalAlcohol!,
                            ),
                          ),
                        if (_bundle.totalCarbohydrate != 0.0)
                          SizedBox(
                            width: 75,
                            child: ChartBar(
                              label: "Carbs",
                              value: _bundle.totalCarbohydrate!,
                              totalValuePct: _bundle.totalCarbohydrate! /
                                  _bundle.totalCarbohydrate!,
                            ),
                          ),
                        if (_bundle.totalFat != 0.0)
                          SizedBox(
                            width: 75,
                            child: ChartBar(
                              label: "Fat",
                              value: _bundle.totalFat!,
                              totalValuePct:
                                  _bundle.totalFat! / _bundle.totalFat!,
                            ),
                          ),
                        if (_bundle.totalFiber != 0.0)
                          SizedBox(
                            width: 75,
                            child: ChartBar(
                              label: "Fiber",
                              value: _bundle.totalFiber!,
                              totalValuePct:
                                  _bundle.totalFiber! / _bundle.totalFiber!,
                            ),
                          ),
                        if (_bundle.totalOrganicAcids != 0.0)
                          SizedBox(
                            width: 75,
                            child: ChartBar(
                              label: "Organic acids",
                              value: _bundle.totalOrganicAcids!,
                              totalValuePct: _bundle.totalOrganicAcids! /
                                  _bundle.totalOrganicAcids!,
                            ),
                          ),
                        if (_bundle.totalProtein != 0.0)
                          SizedBox(
                            width: 75,
                            child: ChartBar(
                              label: "Protein",
                              value: _bundle.totalProtein!,
                              totalValuePct:
                                  _bundle.totalProtein! / _bundle.totalProtein!,
                            ),
                          ),
                        if (_bundle.totalSalt != 0.0)
                          SizedBox(
                            width: 75,
                            child: ChartBar(
                              label: "Salt",
                              value: _bundle.totalSalt!,
                              totalValuePct:
                                  _bundle.totalSalt! / _bundle.totalSalt!,
                            ),
                          ),
                        if (_bundle.totalSaturatedFat != 0.0)
                          SizedBox(
                            width: 75,
                            // height: 15,
                            child: ChartBar(
                              label: "Saturated fat",
                              value: _bundle.totalSaturatedFat!,
                              totalValuePct: _bundle.totalSaturatedFat! /
                                  _bundle.totalSaturatedFat!,
                            ),
                          ),
                        if (_bundle.totalSugar != 0.0)
                          SizedBox(
                            width: 75,
                            child: ChartBar(
                              label: "Sugar",
                              value: _bundle.totalSugar!,
                              totalValuePct:
                                  _bundle.totalSugar! / _bundle.totalSugar!,
                            ),
                          ),
                        if (_bundle.totalSugarAlcohol != 0.0)
                          SizedBox(
                            width: 75,
                            child: ChartBar(
                              label: "Sugar",
                              value: _bundle.totalSugarAlcohol!,
                              totalValuePct: _bundle.totalSugarAlcohol! /
                                  _bundle.totalSugarAlcohol!,
                            ),
                          )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ChartBarHorizontal(
              label: "Kcal",
              value: _bundle.totalEnergyKcal!,
              totalValuePct:
                  _bundle.totalEnergyKcal! / _bundle.totalEnergyKcal!,
            ),
            const SizedBox(
              height: 10,
            ),
            ChartBarHorizontal(
              label: "kJ",
              value: _bundle.totalEnergy!,
              totalValuePct: _bundle.totalEnergy! / _bundle.totalEnergy!,
            ),
            const Divider(
              // indent: 5,
              // endIndent: 5,
              color: Colors.black,
              thickness: 1,
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
