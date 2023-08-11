import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String message;

  const LoadingScreen({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
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
