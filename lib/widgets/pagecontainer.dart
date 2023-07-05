import 'package:flutter/material.dart';

import '../models/appuser_model.dart';

class PageContainer extends StatefulWidget {
  final AppUser user;

  const PageContainer({Key? key, required this.user}) : super(key: key);

  @override
  State<PageContainer> createState() => _PageContainerState();
}

class _PageContainerState extends State<PageContainer> {
  final PageController _pageController = PageController(initialPage: 2);
  late final AppUser _user = widget.user;
  int _selectedIndex = 2;

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
            label: "Food",
            icon: Icon(Icons.emoji_food_beverage),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.person),
          ),
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor: const Color(0xFFE0C3FC),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        // unselectedLabelStyle: TextStyle(color: Colors.black),
        backgroundColor: Colors.deepPurple.shade400,
        onTap: _onItemTapped,
      ),
      body: Padding(padding: const EdgeInsets.only(top: 20.0), child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          Text(_user.email!),
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
