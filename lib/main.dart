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

  final User? _firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final User? _user;

  @override
  void initState() {
    // super.initState();
    _user = widget._firebaseUser;
    // FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //   if (user == null) {
    //     print("Logged out");
    //     // setState(() {
    //     // _user == null;
    //     // });
    //   } else {
    //     print('User is signed in!');
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("user $_user");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      // theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      //   home: const SignIn(),
      //   routes: {
      //     '/loggedIn': (BuildContext context) => PageContainer(user: AppUser()),
      //   },
      // );
      // home: _user == null
      //     ? const SignIn()
      //     : FutureBuilder(
      //         future: FirebaseService.createUser(_user!.uid),
      //         builder: (context, snapshot) {
      //           if (snapshot.hasData) {
      //             return PageContainer(user: snapshot.data!);
      //           }
      //           return const LoadingScreen(
      //             message: "Logging in",
      //           );
      //         },
      //       ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Snapshot has error");
            return const SignIn();
          }
          if (snapshot.data == null) {
            print("User is logged out");
            return const SignIn();
          } else {
            print('User is logged in!');
            return FutureBuilder(
              future: FirebaseService.createUser(snapshot.data!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return PageContainer(user: snapshot.data!);
                }
                return const LoadingScreen(
                  message: "Logging in",
                );
              },
            );
          }
        },
      ),
    );
  }
}
