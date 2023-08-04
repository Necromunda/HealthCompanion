import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoComponentsFound extends StatelessWidget {
  const NoComponentsFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "You dont have any components.",
        style: TextStyle(fontSize: 22),
      ),
    );
  }
}
