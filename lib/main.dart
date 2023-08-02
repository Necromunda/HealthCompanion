import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:health_companion/screens/loading_screen.dart';
import 'package:health_companion/screens/signin_screen.dart';
import 'package:health_companion/widgets/pagecontainer.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

import 'model_theme.dart';

ThemeData get lightTheme => ThemeData(
      useMaterial3: true,
      fontFamily: 'Quicksand',
      brightness: Brightness.dark,
      colorSchemeSeed: Colors.deepPurple,
      dividerColor: Colors.white,
      inputDecorationTheme: const InputDecorationTheme(
        prefixIconColor: Colors.white,
        hintStyle: TextStyle(color: Colors.white),
      ),
    );

ThemeData get darkTheme => ThemeData(
      useMaterial3: true,
      fontFamily: 'Quicksand',
      brightness: Brightness.light,
      colorSchemeSeed: Colors.deepPurple,
      dividerColor: Colors.black,
      // iconTheme: IconThemeData(color: Colors.white),
      inputDecorationTheme: const InputDecorationTheme(
        prefixIconColor: Colors.black,
        hintStyle: TextStyle(color: Colors.black),
        // prefixStyle: TextStyle(color: Colors.black)
      ),
    );

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
            // theme: themeNotifier.isDark ? lightTheme : darkTheme,
            theme: themeNotifier.isDark
                ? ThemeData(
                    useMaterial3: true,
                    pageTransitionsTheme: const PageTransitionsTheme(
                      builders: <TargetPlatform, PageTransitionsBuilder>{
                        TargetPlatform.android:
                            CupertinoPageTransitionsBuilder(),
                      },
                    ),
                    fontFamily: 'Quicksand',
                    brightness: Brightness.dark,
                    colorSchemeSeed: Colors.deepPurple,
                    dividerColor: Colors.white,
                    // cardColor: Theme.of(context).colorScheme.onTertiary,

                    inputDecorationTheme: const InputDecorationTheme(
                      prefixIconColor: Colors.white,
                      hintStyle: TextStyle(color: Colors.white),
                    ),
              // bottomNavigationBarTheme: BottomNavigationBarThemeData(
                // backgroundColor: Theme.of(context).colorScheme.onTertiary
              // )
                  )
                : ThemeData(
                    useMaterial3: true,
                    pageTransitionsTheme: const PageTransitionsTheme(
                      builders: <TargetPlatform, PageTransitionsBuilder>{
                        TargetPlatform.android:
                            CupertinoPageTransitionsBuilder(),
                      },
                    ),
                    fontFamily: 'Quicksand',
                    brightness: Brightness.light,
                    colorSchemeSeed: Colors.deepPurple,
                    dividerColor: Colors.black,
                    inputDecorationTheme: const InputDecorationTheme(
                      prefixIconColor: Colors.black,
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                    // scaffoldBackgroundColor: Colors.deepPurple.shade50,
                  ),
            debugShowCheckedModeBanner: false,
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // return const LoadingScreen(message: "Loading");
                }
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
