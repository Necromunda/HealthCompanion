import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/models/achievement_model.dart';
import 'package:health_companion/services/firebase_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/user_achievement_model.dart';

class Achievements extends StatefulWidget {
  const Achievements({Key? key}) : super(key: key);

  @override
  State<Achievements> createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {
  late final ScrollController _componentAchievementsScrollController,
      _memberAchievementsScrollController;
  late final User _currentUser;
  late final List<UserAchievement> _userAchievements;

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
              _userAchievements = (snapshot.data!['achievements'] as List)
                  .map((e) => UserAchievement.fromJson(e))
                  .toList();

              List<UserAchievement> componentAchievements = _userAchievements
                  .where((element) => element.category == 'component')
                  .toList();
              List<UserAchievement> memberAchievements = _userAchievements
                  .where((element) => element.category == 'member')
                  .toList();

              int componentAchievementsLeft =
                  (4 - componentAchievements.length).abs();
              int memberAchievementsLeft =
                  (4 - memberAchievements.length).abs();

              componentAchievements.addAll(List.generate(
                  componentAchievementsLeft,
                  (index) => UserAchievement.fromJson({
                        'name': 'achievement-locked',
                        'unlockDate': DateTime.now()
                      })).toList());
              memberAchievements.addAll(List.generate(
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
                                itemCount: componentAchievements.length,
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
                                          'assets/images/${componentAchievements[index].name}.png',
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
                                itemCount: memberAchievements.length,
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
                                          'assets/images/${memberAchievements[index].name}.png',
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
