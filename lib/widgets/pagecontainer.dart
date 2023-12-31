import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:health_companion/util.dart';
import 'package:health_companion/screens/search_screen.dart';
import 'package:health_companion/screens/profile_screen.dart';
import 'package:health_companion/screens/overview_screen.dart';
import 'package:health_companion/screens/settings_screen.dart';
import 'package:health_companion/screens/components_screen.dart';
import 'package:health_companion/services/firebase_service.dart';

class PageContainer extends StatefulWidget {
  const PageContainer({Key? key}) : super(key: key);

  @override
  State<PageContainer> createState() => _PageContainerState();
}

class _PageContainerState extends State<PageContainer> {
  late final User _currentUser;
  late final PageController _pageController;
  late int _currentPageIndex, _maxPageDistance;

  @override
  void initState() {
    print("Pagcontainer init");
    _pageController = PageController(initialPage: 2);
    _currentPageIndex = 2;
    _maxPageDistance = 1;
    _currentUser = FirebaseAuth.instance.currentUser!;
    _checkAccountCreationDate();
    super.initState();
  }

  void _checkAccountCreationDate() {
    int days =
        DateTime.now().difference(_currentUser.metadata.creationTime!).inDays;

    if (days >= 365) {
      FirebaseService.addAchievement(context, UserAchievementType.member365);
    } else if (days >= 165) {
      FirebaseService.addAchievement(context, UserAchievementType.member165);
    } else if (days >= 28) {
      FirebaseService.addAchievement(context, UserAchievementType.member28);
    } else if (days >= 7) {
      FirebaseService.addAchievement(context, UserAchievementType.member7);
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    int distance = (index - _currentPageIndex).abs();

    if (distance <= _maxPageDistance) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.jumpToPage(index);
    }
  }

  Color? get navBarColor => Util.isDark(context)
      ? Theme.of(context).colorScheme.onTertiary
      : Theme.of(context).colorScheme.tertiary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.settings,
            icon: const Icon(Icons.settings),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.search,
            icon: const Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.overview,
            icon: const Icon(Icons.menu),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.components,
            icon: const Icon(Icons.emoji_food_beverage),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.profile,
            icon: const Icon(Icons.person),
          ),
        ],
        currentIndex: _currentPageIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        backgroundColor: navBarColor,
        onTap: _onItemTapped,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const <Widget>[
            SettingsScreen(),
            Search(),
            Overview(),
            Components(),
            Profile(),
          ],
          onPageChanged: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
        ),
      ),
    );
  }
}
