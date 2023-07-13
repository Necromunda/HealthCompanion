import 'package:flutter/material.dart';

class SignUpInfoCard extends StatelessWidget {
  final String hint;

  const SignUpInfoCard({Key? key, required this.hint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.only(top: 25.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            hint,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
