import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingScreen extends StatelessWidget {
  final String message;

  const LoadingScreen({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Image.asset("assets/images/HealthCompanion-Logo2.png"),
          const SizedBox(
            height: 100,
          ),
          Text(message),
        ],
      ),
    ));
  }
}
// Center(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// const Padding(
// padding: EdgeInsets.only(bottom: 15.0),
// child: CircularProgressIndicator(),
// ),
// Text(message),
// ],
// ),
// ),
