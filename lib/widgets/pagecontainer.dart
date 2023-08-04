import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/screens/components_screen.dart';
import 'package:health_companion/screens/overview_screen.dart';
import 'package:health_companion/screens/profile_screen.dart';
import 'package:health_companion/screens/search_screen.dart';
import 'package:health_companion/screens/settings_screen.dart';
import 'package:health_companion/services/firebase_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../util.dart';

class PageContainer extends StatefulWidget {
  const PageContainer({Key? key}) : super(key: key);

  @override
  State<PageContainer> createState() => _PageContainerState();
}

class _PageContainerState extends State<PageContainer> {
  late final User _currentUser;
  late final PageController _pageController;
  late int _currentPageIndex, _maxPageDistance;
  // late Stream _statsDocumentReference;

  @override
  void initState() {
    print("Pagcontainer init");
    _pageController = PageController(initialPage: 2);
    _currentPageIndex = 2;
    _maxPageDistance = 1;
    _currentUser = FirebaseAuth.instance.currentUser!;
    _checkAccountCreationDate();
    // _statsDocumentReference = FirebaseFirestore.instance.collection('user_stats').doc(_currentUser.uid).snapshots();
    // FirebaseAuth.instance.idTokenChanges().listen((event) {
    //   if (event != null) {
    //     _statsDocumentReference.listen((event) {
    //       print(event);
    //     });
    //   }
    // });
    super.initState();
  }

  void _checkAccountCreationDate() {
    int days =
        DateTime.now().difference(_currentUser.metadata.creationTime!).inDays;

    if (days >= 365) {
      print("Account  is 1 year old");
      FirebaseService.addAchievement(context, UserAchievementType.member365);
    } else if (days >= 165) {
      print("Account  is 6 months old");
      FirebaseService.addAchievement(context, UserAchievementType.member165);
    } else if (days >= 28) {
      print("Account  is 1 month old");
      FirebaseService.addAchievement(context, UserAchievementType.member28);
    } else if (days >= 7) {
      print("Account  is 7 days old");
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
        items: const [
          BottomNavigationBarItem(
            label: "Settings",
            icon: Icon(Icons.settings),
          ),
          BottomNavigationBarItem(
            label: "Search",
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            label: "Overview",
            icon: Icon(Icons.menu),
          ),
          BottomNavigationBarItem(
            label: "Components",
            icon: Icon(Icons.emoji_food_beverage),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.person),
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
