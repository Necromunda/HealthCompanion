import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/models/appuser_model.dart';
import 'package:health_companion/screens/achievements_screen.dart';
import 'package:health_companion/screens/delete_account_screen.dart';
import 'package:health_companion/screens/loading_screen.dart';
import 'package:health_companion/screens/stats_screen.dart';
import 'package:intl/intl.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late final User _currentUser;
  late final Stream _userDocStream;

  @override
  void initState() {
    _currentUser = FirebaseAuth.instance.currentUser!;
    _userDocStream =
        FirebaseFirestore.instance.collection("users").doc(_currentUser.uid).snapshots();
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
    // bool? res = await _showDeleteAccountConfirm();
    // print("Delete account: $res");
    // if (res is bool && res) {
    //   FirebaseAuth.instance.currentUser!.reauthenticateWithCredential()
    //   print("deleting account");
    // }
    bool? res = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DeleteAccount(),
      ),
    );
  }

  Future<bool?> _showDeleteAccountConfirm() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Delete account",
          textAlign: TextAlign.center,
        ),
        content: const Text(
          "Are you sure you want to delete your account?\nAccount deletion is permanent.",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text("Cancel"),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text("Delete"),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          String dateOfBirth = DateFormat('d.M.yyyy').format(appUser.dateOfBirth!);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0), // Adjust the value as needed
                  child: Image.asset(
                    "assets/images/profile-picture-placeholder.jpg", // Replace with your image URL
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
                      children: const [
                        Text(
                          "Username",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Joined",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Date of birth",
                          style: TextStyle(fontSize: 18),
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
                ListTile(
                  title: const Text(
                    "Stats",
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: const Icon(Icons.launch),
                  // onTap: _statsButtonHandler,
                  onTap: _statsButtonHandler,
                  minVerticalPadding: 0.0,
                  shape: const Border(bottom: BorderSide()),
                ),
                ListTile(
                  title: const Text(
                    "Achievements",
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: const Icon(Icons.launch),
                  // onTap: _statsButtonHandler,
                  onTap: _achievementsButtonHandler,
                  minVerticalPadding: 0.0,
                  shape: const Border(bottom: BorderSide()),
                ),
                ListTile(
                  title: const Text(
                    "Delete account",
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: const Icon(Icons.launch),
                  // onTap: _statsButtonHandler,
                  onTap: _deleteAccountButtonHandler,
                  minVerticalPadding: 0.0,
                  shape: const Border(bottom: BorderSide()),
                ),
                const Expanded(child: SizedBox()),
                Align(
                  alignment: Alignment.bottomCenter,
                  // alignment: ,
                  child: TextButton(
                    onPressed: _logout,
                    child: const Text(
                      "Log out",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
              ],
            ),
          );
        }
        return const LoadingScreen(message: "Loading profile");
      },
    );
  }
}
