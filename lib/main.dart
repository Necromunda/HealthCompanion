import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:health_companion/screens/signin_screen.dart';
import 'package:health_companion/widgets/pagecontainer.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

import 'model_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ModelTheme(),
      child: Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
          return MaterialApp(
            theme: themeNotifier.isDark
                ? ThemeData(
                    useMaterial3: true,
                    brightness: Brightness.dark,
                    primarySwatch: Colors.deepPurple,
                    primaryColor: Colors.deepPurple.shade400,
                  )
                : ThemeData(
                    useMaterial3: true,
                    brightness: Brightness.light,
                    primarySwatch: Colors.deepPurple,
                    primaryColor: Colors.deepPurple.shade400,
                  ),
            debugShowCheckedModeBanner: false,
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              // stream: FirebaseAuth.instance.idTokenChanges(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  print('User is logged out!');
                  return const SignIn();
                }
                print('User is logged in!');
                return const PageContainer();
              },
            ),
          );
        },
      ),
    );
  }
}

// class MyApp extends StatefulWidget {
//   MyApp({super.key});
//
//   final User? _firebaseUser = FirebaseAuth.instance.currentUser;
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   late final User? _user;
//
//   @override
//   void initState() {
//     _user = widget._firebaseUser;
//     super.initState();
//   }
//
//   // @override
//   // Widget build(BuildContext context) {
//   //   print("user $_user");
//   //   return MaterialApp(
//   //     debugShowCheckedModeBanner: false,
//   //     theme: ThemeData(primarySwatch: Colors.deepPurple),
//   //     darkTheme: ThemeData.dark(),
//   //     home: StreamBuilder(
//   //       stream: FirebaseAuth.instance.authStateChanges(),
//   //       builder: (context, snapshot) {
//   //         if (!snapshot.hasData) {
//   //           print("Direct log in");
//   //           return const SignIn();
//   //         }
//   //         print('User is logged in!');
//   //         return const PageContainer();
//   //       },
//   //     ),
//   //   );
//   // }
//
//   // @override
//   // Widget build(BuildContext context) {
//   //   return ChangeNotifierProvider(
//   //     create: (_) => ModelTheme(),
//   //     child: Consumer<ModelTheme>(
//   //       builder: (context, ModelTheme themeNotifier, child) {
//   //         return MaterialApp(
//   //           theme: themeNotifier.isDark
//   //               ? ThemeData(
//   //             useMaterial3: true,
//   //             brightness: Brightness.dark,
//   //             primarySwatch: Colors.deepPurple,
//   //             primaryColor: Colors.deepPurple.shade400,
//   //           )
//   //               : ThemeData(
//   //             useMaterial3: true,
//   //             brightness: Brightness.light,
//   //             primarySwatch: Colors.deepPurple,
//   //             primaryColor: Colors.deepPurple.shade400,
//   //           ),
//   //           debugShowCheckedModeBanner: false,
//   //           home: StreamBuilder(
//   //             stream: FirebaseAuth.instance.authStateChanges(),
//   //             builder: (context, snapshot) {
//   //               if (!snapshot.hasData) {
//   //                 print('User is logged out!');
//   //                 return const SignIn();
//   //               }
//   //               print('User is logged in!');
//   //               return const PageContainer();
//   //             },
//   //           ),
//   //         );
//   //       },
//   //     ),
//   //   );
//   // }
// }
