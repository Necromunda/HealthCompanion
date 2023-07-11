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
  static const String _username = "testiukko";
  static const String _email = "testi@gmail.com";
  static const String _password = "testi123";

  void _test() async {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: _email, password: _password)
        .then(
      (responseData) async {
        User? user = responseData.user;
        await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
          'username': _username,
          'email': _email,
          'joinDate': user?.metadata.creationTime,
        });
      },
    ).onError(
      (error, stackTrace) {
        print(error);
        print(stackTrace);
      },
    );
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
            return PageContainer(
              user: snapshot.data!
              // user: AppUser.fromJson({})
            );
          }
          return const LoadingScreen();
        },
      ),
    );
  }
}
