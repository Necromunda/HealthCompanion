import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:health_companion/screens/loading_screen.dart';
import 'package:health_companion/screens/signin_screen.dart';
import 'package:health_companion/services/firebase_service.dart';
import 'package:health_companion/widgets/pagecontainer.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

import 'models/appuser_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  User? _firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print("Logged out");
        // setState(() {
        //   widget._firebaseUser = user;
        //   print(widget._firebaseUser);
        // });
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      // theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      home: widget._firebaseUser == null
          ? const SignIn()
          : FutureBuilder(
              future: FirebaseService.createUser(widget._firebaseUser!.uid),
              // future: null,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return PageContainer(user: snapshot.data!
                      // user: AppUser.fromJson({})
                      );
                }
                return const LoadingScreen();
              },
            ),
    );
  }
}
