import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingScreen extends StatelessWidget {
  final String message;

  const LoadingScreen({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Image.asset("assets/images/HealthCompanion-Logo2.png"),
            const SizedBox(
              height: 300,
            ),
            Text(message),
          ],
        ),
      ),
    );
  }
}
