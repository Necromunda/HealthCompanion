import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoComponentsFound extends StatelessWidget {
  const NoComponentsFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.noComponents,
        style: const TextStyle(fontSize: 22),
      ),
    );
  }
}
