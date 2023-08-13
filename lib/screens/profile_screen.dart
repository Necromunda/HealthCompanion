import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:health_companion/models/appuser_model.dart';
import 'package:health_companion/screens/stats_screen.dart';
import 'package:health_companion/screens/achievements_screen.dart';
import 'package:health_companion/screens/delete_account_screen.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile>
    with AutomaticKeepAliveClientMixin<Profile> {
  late final User _currentUser;
  late final Stream _userDocStream;

  @override
  void initState() {
    _currentUser = FirebaseAuth.instance.currentUser!;
    _userDocStream = FirebaseFirestore.instance
        .collection("users")
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
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Profile oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  bool get wantKeepAlive => true;

  void _logout() async {
    FirebaseAuth.instance.signOut().then((_) {
      Navigator.of(context).popUntil(ModalRoute.withName("/"));
    }).catchError((_) {
      print("Error logging out");
    });
  }

  void _statsButtonHandler() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Stats(),
      ),
    );
  }

  void _achievementsButtonHandler() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Achievements(),
      ),
    );
  }

  void _deleteAccountButtonHandler() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DeleteAccount(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: _userDocStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Error loading profile."),
          );
        } else if (snapshot.hasData && snapshot.data.data() != null) {
          Map<String, dynamic> json = snapshot.data.data();
          AppUser appUser = AppUser.fromJson(json);
          String joinDate = DateFormat('d.M.yyyy').format(appUser.joinDate!);
          String dateOfBirth =
              DateFormat('d.M.yyyy').format(appUser.dateOfBirth!);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  // Adjust the value as needed
                  child: Image.asset(
                    "assets/images/profile-picture-placeholder.jpg",
                    // Replace with your image URL
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.username,
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          AppLocalizations.of(context)!.joined,
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          AppLocalizations.of(context)!.dateOfBirth,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${appUser.username}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          joinDate,
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          dateOfBirth,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                Card(
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          AppLocalizations.of(context)!.stats,
                          style: const TextStyle(fontSize: 18),
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: _statsButtonHandler,
                        minVerticalPadding: 0.0,
                      ),
                      const Divider(
                        height: 0,
                        indent: 10,
                        endIndent: 10,
                        color: Colors.black,
                      ),
                      ListTile(
                        title: Text(
                          AppLocalizations.of(context)!.achievements,
                          style: const TextStyle(fontSize: 18),
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: _achievementsButtonHandler,
                        minVerticalPadding: 0.0,
                      ),
                      const Divider(
                        height: 0,
                        indent: 10,
                        endIndent: 10,
                        color: Colors.black,
                      ),
                      ListTile(
                        title: Text(
                          AppLocalizations.of(context)!.deleteAccount,
                          style: const TextStyle(fontSize: 18),
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: _deleteAccountButtonHandler,
                        minVerticalPadding: 0.0,
                      ),
                    ],
                  ),
                ),
                const Expanded(child: SizedBox()),
                Align(
                  alignment: Alignment.bottomCenter,
                  // alignment: ,
                  child: TextButton(
                    onPressed: _logout,
                    child: Text(
                      AppLocalizations.of(context)!.signOut,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                )
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
