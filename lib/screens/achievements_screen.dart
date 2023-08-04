import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/models/achievement_model.dart';
import 'package:health_companion/services/firebase_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../models/user_achievements_model.dart';

class Achievements extends StatefulWidget {
  const Achievements({Key? key}) : super(key: key);

  @override
  State<Achievements> createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {
  late final ScrollController _componentAchievementsScrollController,
      _memberAchievementsScrollController;
  late final User _currentUser;
  late final List<UserAchievements> _userAchievements;

  @override
  void initState() {
    print("Overview screen init");
    _currentUser = FirebaseAuth.instance.currentUser!;
    _componentAchievementsScrollController = ScrollController();
    _memberAchievementsScrollController = ScrollController();
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
    _componentAchievementsScrollController.dispose();
    _memberAchievementsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: FutureBuilder(
          future: FirebaseService.getUserAchievements(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(AppLocalizations.of(context)!.error),
              );
            }
            if (snapshot.hasData) {
              UserAchievements userAchievements =
                  UserAchievements.fromJson(snapshot.data!);
              int componentAchievementsLeft =
                  (4 - userAchievements.componentAchievements!.length).abs();
              int memberAchievementsLeft =
              (4 - userAchievements.memberAchievements!.length).abs();

              userAchievements.componentAchievements?.addAll(List.generate(
                  componentAchievementsLeft,
                  (index) => UserAchievement.fromJson({
                        'name': 'achievement-locked',
                        'unlockDate': DateTime.now()
                      })).toList());
              userAchievements.memberAchievements?.addAll(List.generate(
                  memberAchievementsLeft,
                      (index) => UserAchievement.fromJson({
                    'name': 'achievement-locked',
                    'unlockDate': DateTime.now()
                  })).toList());

              return Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                    AppLocalizations.of(context)!.component(2),
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(AppLocalizations.of(context)!.more),
                              ),
                            ],
                          ),
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: ListView.builder(
                                controller:
                                    _componentAchievementsScrollController,
                                itemCount: userAchievements
                                    .componentAchievements?.length,
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    child: Center(
                                      child: SizedBox(
                                        height: 200,
                                        width: 100,
                                        child: Image.asset(
                                          'assets/images/${userAchievements.componentAchievements?[index].name}.png',
                                          // 'assets/images/achievement-unlock.png',
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  AppLocalizations.of(context)!.member,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(AppLocalizations.of(context)!.more),
                              ),
                            ],
                          ),
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: ListView.builder(
                                controller: _memberAchievementsScrollController,
                                itemCount:
                                    userAchievements.memberAchievements?.length,
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    child: Center(
                                      child: SizedBox(
                                        height: 200,
                                        width: 100,
                                        child: Image.asset(
                                          'assets/images/${userAchievements.memberAchievements?[index].name}.png',
                                          // 'assets/images/achievement-unlock.png',
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return Center(
              child: Text(AppLocalizations.of(context)!.loading),
            );
          },
        ),
      ),
    );
  }
}

// class Achievements extends StatelessWidget {
//   const Achievements({Key? key}) : super(key: key);

// late Achievement _componentAchievements;

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       backgroundColor: Colors.transparent,
//       elevation: 0.0,
//       leading: IconButton(
//         onPressed: () => Navigator.of(context).pop(),
//         icon: const Icon(Icons.close),
//       ),
//     ),
//     body: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: Column(
//         children: [
//           SizedBox(
//             width: double.infinity,
//             height: 150,
//             child: Card(
//               clipBehavior: Clip.antiAlias,
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 10),
//                         child: Text(
//                           "Components",
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           // FirebaseService.setUserInfo();
//                         },
//                         child: const Text("More"),
//                       ),
//                     ],
//                   ),
//                   Expanded(
//                     child: SizedBox(
//                         // height: 150,
//                         width: double.infinity,
//                         child: FutureBuilder(
//                           future:
//                               FirebaseService.getAchievements('components'),
//                           builder: (context, snapshot) {
//                             if (snapshot.hasError) {
//                               return const Text("error");
//                             }
//                             if (snapshot.hasData) {
//                               print(snapshot.data);
//                               // List<Achievement> componentAchievements = snapshot.data!;
//
//                               return ListView.builder(
//                                 // shrinkWrap: true,
//                                 // itemCount: componentAchievements.length,
//                                 itemCount: snapshot.data?.length,
//                                 scrollDirection: Axis.horizontal,
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 5),
//                                 itemBuilder: (context, index) {
//                                   return Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 5),
//                                     child: Center(
//                                       child: SizedBox(
//                                         height: 200,
//                                         width: 100,
//                                         child: Image.asset(
//                                             'assets/images/${snapshot.data![index].name}.png'),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//                             }
//                             return const Text("Loading");
//                           },
//                         )),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   )
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(
//             width: double.infinity,
//             height: 150,
//             child: Card(
//               clipBehavior: Clip.antiAlias,
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: const [
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 10),
//                         child: Text(
//                           "Member",
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: null,
//                         child: Text("More"),
//                       ),
//                     ],
//                   ),
//                   Expanded(
//                     child: SizedBox(
//                       // height: 150,
//                       width: double.infinity,
//                       child: ListView.builder(
//                         // shrinkWrap: true,
//                         itemCount: 10,
//                         scrollDirection: Axis.horizontal,
//                         padding: const EdgeInsets.symmetric(horizontal: 5),
//                         itemBuilder: (context, index) {
//                           return Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 5),
//                             child: Center(
//                               child: Container(
//                                 height: 200,
//                                 width: 100,
//                                 color:
//                                     Theme.of(context).colorScheme.onTertiary,
//                                 child: Text(
//                                   "Achievement\n${index + 1}",
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                             ),
//                           );
//                           // return Padding(
//                           //   padding: const EdgeInsets.all(5),
//                           //   child: Image.network(
//                           //     "https://logo.uplead.com/amazon.com",
//                           //     // scale: 0.5,
//                           //   ),
//                           // );
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       backgroundColor: Colors.transparent,
//       elevation: 0.0,
//       leading: IconButton(
//         onPressed: () => Navigator.of(context).pop(),
//         icon: const Icon(Icons.close),
//       ),
//     ),
//     body: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: Column(
//         // mainAxisSize: MainAxisSize.max,
//         children: [
//           FutureBuilder(
//             future: Future.delayed(Duration(seconds: 5)),
//             builder: (BuildContext context, snapshot) {
//               if (snapshot.hasError) {
//                 return const Center(
//                   child: Text("Error"),
//                 );
//               }
//               return Column(
//                 children: [
//                   SizedBox(
//                     width: double.infinity,
//                     height: 150,
//                     child: Card(
//                       clipBehavior: Clip.antiAlias,
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: const [
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 10),
//                                 child: Text(
//                                   "Components",
//                                   style: TextStyle(fontSize: 18),
//                                 ),
//                               ),
//                               TextButton(
//                                 onPressed: null,
//                                 child: Text("More"),
//                               ),
//                             ],
//                           ),
//                           Expanded(
//                             child: SizedBox(
//                               // height: 150,
//                               width: double.infinity,
//                               child: ListView.builder(
//                                 // shrinkWrap: true,
//                                 itemCount: 10,
//                                 scrollDirection: Axis.horizontal,
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 5),
//                                 itemBuilder: (context, index) {
//                                   return Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 5),
//                                     child: Center(
//                                       child: Container(
//                                         height: 200,
//                                         width: 100,
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onTertiary,
//                                         child: Text(
//                                           "Achievement\n${index + 1}",
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                   // return Padding(
//                                   //   padding: const EdgeInsets.all(5),
//                                   //   child: Image.network(
//                                   //     "https://logo.uplead.com/amazon.com",
//                                   //     // scale: 0.5,
//                                   //   ),
//                                   // );
//                                 },
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 150,
//                     child: Card(
//                       clipBehavior: Clip.antiAlias,
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: const [
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 10),
//                                 child: Text(
//                                   "Member",
//                                   style: TextStyle(fontSize: 18),
//                                 ),
//                               ),
//                               TextButton(
//                                 onPressed: null,
//                                 child: Text("More"),
//                               ),
//                             ],
//                           ),
//                           Expanded(
//                             child: SizedBox(
//                               // height: 150,
//                               width: double.infinity,
//                               child: ListView.builder(
//                                 // shrinkWrap: true,
//                                 itemCount: 10,
//                                 scrollDirection: Axis.horizontal,
//                                 padding:
//                                 const EdgeInsets.symmetric(horizontal: 5),
//                                 itemBuilder: (context, index) {
//                                   return Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 5),
//                                     child: Center(
//                                       child: Container(
//                                         height: 200,
//                                         width: 100,
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onTertiary,
//                                         child: Text(
//                                           "Achievement\n${index + 1}",
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                   // return Padding(
//                                   //   padding: const EdgeInsets.all(5),
//                                   //   child: Image.network(
//                                   //     "https://logo.uplead.com/amazon.com",
//                                   //     // scale: 0.5,
//                                   //   ),
//                                   // );
//                                 },
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     ),
//   );
// }
// }
