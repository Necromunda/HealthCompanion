import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordInstructions extends StatelessWidget {
  final String email;

  const ForgotPasswordInstructions({Key? key, required this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 25.0),
          child: Icon(
            Icons.send,
            size: 32,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.forgotPasswordInstructions,
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        Text(
          email,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
