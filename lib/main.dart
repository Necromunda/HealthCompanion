import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:health_companion/firebase_options.dart';
import 'package:health_companion/model_preferences.dart';
import 'package:health_companion/widgets/pagecontainer.dart';
import 'package:health_companion/screens/signin_screen.dart';

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
      create: (_) => ModelPreferences(),
      child: Consumer<ModelPreferences>(
        builder: (context, ModelPreferences themeNotifier, child) {
          return MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale.fromSubtags(languageCode: themeNotifier.locale),
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
                    inputDecorationTheme: const InputDecorationTheme(
                      prefixIconColor: Colors.white,
                      hintStyle: TextStyle(color: Colors.white),
                    ),
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
