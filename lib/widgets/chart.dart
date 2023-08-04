import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/widgets/chartbar.dart';
import 'package:health_companion/widgets/chartbar_horizontal.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/bundle_model.dart';
import '../models/user_preferences_model.dart';

class Chart extends StatefulWidget {
  final Bundle bundle;
  final UserPreferences? userPreferences;

  const Chart({Key? key, required this.bundle, required this.userPreferences}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  // late final User _currentUser;
  late final Bundle _bundle;
  final ScrollController _scrollController = ScrollController();
  // late final Stream _userPreferencesDocStream;
  late final UserPreferences? prefs;

  @override
  void initState() {
    print("Chart screen init");
    // _currentUser = FirebaseAuth.instance.currentUser!;
    _bundle = widget.bundle;
    prefs = widget.userPreferences;
    // _userPreferencesDocStream = FirebaseFirestore.instance
    //     .collection("user_preferences")
    //     .doc(_currentUser.uid)
    //     .snapshots();
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
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
        child: Column(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_bundle.totalAlcohol != 0.0)
                          SizedBox(
                            width: 75,
                            child: ChartBar(
                              label: AppLocalizations.of(context)!.macro('alcohol'),
                              value: _bundle.totalAlcohol!,
                              goal: prefs?.alcohol ?? 0,
                            ),
                          ),
                        if (_bundle.totalCarbohydrate != 0.0)
                          SizedBox(
                            width: 75,
                            child: ChartBar(
                              label: AppLocalizations.of(context)!.macro('carbohydrate'),
                              value: _bundle.totalCarbohydrate!,
                              goal: prefs?.carbohydrate ?? 0,
                            ),
                          ),
                        if (_bundle.totalFat != 0.0)
                          SizedBox(
                            width: 75,
                            child: ChartBar(
                              label: AppLocalizations.of(context)!.macro('fat'),
                              value: _bundle.totalFat!,
                              goal: prefs?.fat ?? 0,
                            ),
                          ),
                        if (_bundle.totalFiber != 0.0)
                          SizedBox(
                            width: 75,
                            child: ChartBar(
                              label: AppLocalizations.of(context)!.macro('fiber'),
                              value: _bundle.totalFiber!,
                              goal: prefs?.fiber ?? 0,
                            ),
                          ),
                        if (_bundle.totalOrganicAcids != 0.0)
                          SizedBox(
                            width: 75,
                            child: ChartBar(
                              label: AppLocalizations.of(context)!.macro('organicacids'),
                              value: _bundle.totalOrganicAcids!,
                              goal: prefs?.organicAcids ?? 0,
                            ),
                          ),
                        if (_bundle.totalProtein != 0.0)
                          SizedBox(
                            width: 75,
                            child: ChartBar(
                              label: AppLocalizations.of(context)!.macro('protein'),
                              value: _bundle.totalProtein!,
                              goal: prefs?.protein ?? 0,
                            ),
                          ),
                        if (_bundle.totalSalt != 0.0)
                          SizedBox(
                            width: 75,
                            child: ChartBar(
                              label: AppLocalizations.of(context)!.macro('salt'),
                              value: _bundle.totalSalt!,
                              goal: prefs?.salt ?? 0,
                            ),
                          ),
                        if (_bundle.totalSaturatedFat != 0.0)
                          SizedBox(
                            width: 75,
                            // height: 15,
                            child: ChartBar(
                              label: AppLocalizations.of(context)!.macro('saturatedfat'),
                              value: _bundle.totalSaturatedFat!,
                              goal: prefs?.saturatedFat ?? 0,
                            ),
                          ),
                        if (_bundle.totalSugar != 0.0)
                          SizedBox(
                            width: 75,
                            child: ChartBar(
                              label: AppLocalizations.of(context)!.macro('sugar'),
                              value: _bundle.totalSugar!,
                              goal: prefs?.sugar ?? 0,
                            ),
                          ),
                        if (_bundle.totalSugarAlcohol != 0.0)
                          SizedBox(
                            width: 75,
                            child: ChartBar(
                              label: AppLocalizations.of(context)!.macro('sugaralcohol'),
                              value: _bundle.totalSugarAlcohol!,
                              goal: prefs?.sugarAlcohol ?? 0,
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
            if (_bundle.totalEnergyKcal != 0.0)
              ChartBarHorizontal(
                label: "Kcal",
                value: _bundle.totalEnergyKcal!,
                goal: prefs?.energyKcal ?? 0,
              ),
            const SizedBox(
              height: 10,
            ),
            if (_bundle.totalEnergy != 0.0)
              ChartBarHorizontal(
                label: "kJ",
                value: _bundle.totalEnergy!,
                goal: prefs?.energyKj ?? 0,
              ),
            const Divider(
              color: Colors.black,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return SizedBox(
  //     width: double.infinity,
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
  //       child: StreamBuilder(
  //         stream: _userPreferencesDocStream,
  //         builder: (context, snapshot) {
  //           if (snapshot.hasError) {
  //             return const Center(child: Text("error"));
  //           }
  //           if (snapshot.hasData) {
  //             UserPreferences prefs =
  //                 UserPreferences.fromJson(snapshot.data.data());
  //             // print(prefs.alcohol);
  //
  //             return Column(
  //               children: [
  //                 SingleChildScrollView(
  //                   controller: _scrollController,
  //                   scrollDirection: Axis.horizontal,
  //                   child: Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 10.0),
  //                     child: Column(
  //                       children: [
  //                         Row(
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             if (_bundle.totalAlcohol != 0.0)
  //                               SizedBox(
  //                                 width: 75,
  //                                 child: ChartBar(
  //                                   label: "Alcohol",
  //                                   value: _bundle.totalAlcohol!,
  //                                   goal: prefs.alcohol,
  //                                 ),
  //                               ),
  //                             if (_bundle.totalCarbohydrate != 0.0)
  //                               SizedBox(
  //                                 width: 75,
  //                                 child: ChartBar(
  //                                   label: "Carbs",
  //                                   value: _bundle.totalCarbohydrate!,
  //                                   goal: prefs.carbohydrate,
  //                                 ),
  //                               ),
  //                             if (_bundle.totalFat != 0.0)
  //                               SizedBox(
  //                                 width: 75,
  //                                 child: ChartBar(
  //                                   label: "Fat",
  //                                   value: _bundle.totalFat!,
  //                                   goal: prefs.fat,
  //                                 ),
  //                               ),
  //                             if (_bundle.totalFiber != 0.0)
  //                               SizedBox(
  //                                 width: 75,
  //                                 child: ChartBar(
  //                                   label: "Fiber",
  //                                   value: _bundle.totalFiber!,
  //                                   goal: prefs.fiber,
  //                                 ),
  //                               ),
  //                             if (_bundle.totalOrganicAcids != 0.0)
  //                               SizedBox(
  //                                 width: 75,
  //                                 child: ChartBar(
  //                                   label: "Organic acids",
  //                                   value: _bundle.totalOrganicAcids!,
  //                                   goal: prefs.organicAcids,
  //                                 ),
  //                               ),
  //                             if (_bundle.totalProtein != 0.0)
  //                               SizedBox(
  //                                 width: 75,
  //                                 child: ChartBar(
  //                                   label: "Protein",
  //                                   value: _bundle.totalProtein!,
  //                                   goal: prefs.protein,
  //                                 ),
  //                               ),
  //                             if (_bundle.totalSalt != 0.0)
  //                               SizedBox(
  //                                 width: 75,
  //                                 child: ChartBar(
  //                                   label: "Salt",
  //                                   value: _bundle.totalSalt!,
  //                                   goal: prefs.salt,
  //                                 ),
  //                               ),
  //                             if (_bundle.totalSaturatedFat != 0.0)
  //                               SizedBox(
  //                                 width: 75,
  //                                 // height: 15,
  //                                 child: ChartBar(
  //                                   label: "Saturated fat",
  //                                   value: _bundle.totalSaturatedFat!,
  //                                   goal: prefs.saturatedFat,
  //                                 ),
  //                               ),
  //                             if (_bundle.totalSugar != 0.0)
  //                               SizedBox(
  //                                 width: 75,
  //                                 child: ChartBar(
  //                                   label: "Sugar",
  //                                   value: _bundle.totalSugar!,
  //                                   goal: prefs.sugar,
  //                                 ),
  //                               ),
  //                             if (_bundle.totalSugarAlcohol != 0.0)
  //                               SizedBox(
  //                                 width: 75,
  //                                 child: ChartBar(
  //                                   label: "Sugar alcohol",
  //                                   value: _bundle.totalSugarAlcohol!,
  //                                   goal: prefs.sugarAlcohol,
  //                                 ),
  //                               )
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   height: 15,
  //                 ),
  //                 if (_bundle.totalEnergyKcal != 0.0)
  //                 ChartBarHorizontal(
  //                   label: "Kcal",
  //                   value: _bundle.totalEnergyKcal!,
  //                   goal: prefs.energyKcal,
  //                 ),
  //                 const SizedBox(
  //                   height: 10,
  //                 ),
  //                 if (_bundle.totalEnergy != 0.0)
  //                 ChartBarHorizontal(
  //                   label: "kJ",
  //                   value: _bundle.totalEnergy!,
  //                   goal: prefs.energyKj,
  //                 ),
  //                 const Divider(
  //                   color: Colors.black,
  //                   thickness: 1,
  //                 ),
  //               ],
  //             );
  //           }
  //           return const Text("Loading preferences");
  //         },
  //       ),
  //     ),
  //   );
  // }
}
