import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/screens/components_screen.dart';
import 'package:health_companion/screens/overview_screen.dart';
import 'package:health_companion/screens/profile_screen.dart';
import 'package:health_companion/screens/search_screen.dart';
import 'package:health_companion/screens/settings_screen.dart';

import '../models/appuser_model.dart';
import '../models/component_model.dart';

class PageContainer extends StatefulWidget {
  // final AppUser user;

  // const PageContainer({Key? key, required this.user}) : super(key: key);
  const PageContainer({Key? key}) : super(key: key);

  @override
  State<PageContainer> createState() => _PageContainerState();
}

class _PageContainerState extends State<PageContainer> {
  late final PageController _pageController;
  // late final AppUser _user;
  late int _selectedIndex;
  late final FirebaseFirestore _firestore;
  // late final DocumentReference _documentRef;
  // late List<Component> _userComponents;
  // late StreamSubscription<DocumentSnapshot> _documentSubscription;
  // late StreamSubscription<User?> _userSubscription;

  @override
  void initState() {
    print("Pagcontainer init");
    // _user = widget.user;
    // _firestore = FirebaseFirestore.instance;
    // _documentRef = _firestore.collection("user_components").doc(_user.uid);
    _pageController = PageController(initialPage: 2);
    _selectedIndex = 2;
    // _userComponents = [];
    // _subscribeToDocumentChanges();
    super.initState();
  }

  // void _subscribeToDocumentChanges() {
  //   _userSubscription = FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //     if (user == null) {
  //       print("Logged out");
  //       _documentSubscription.cancel();
  //       _userSubscription.cancel();
  //       // setState(() {
  //       //   widget._firebaseUser = user;
  //       //   print(widget._firebaseUser);
  //       // });
  //     } else {
  //       print('User is signed in!');
  //     }
  //   });
  //   _documentSubscription = _documentRef.snapshots().listen((DocumentSnapshot snapshot) {
  //     if (snapshot.exists) {
  //       final data = snapshot.data();
  //       print("Components updated");
  //       setState(() {
  //         _userComponents =
  //             ((data as Map)["components"] as List).map((e) => Component.fromJson(e)).toList();
  //         print(_userComponents.length);
  //       });
  //     }
  //   }, onError: (e, stackTrace) {
  //     print("ERROR: $e");
  //   });
  // }

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
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.deepPurple.shade400,
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
            // Overview(user: _user,),
            Overview(),
            // Components(user: _user,
            Components(),
            Profile()
          ],
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
