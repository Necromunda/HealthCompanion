import 'package:flutter/material.dart';

import '../models/component_model.dart';

class ComponentBreakdown extends StatelessWidget {
  final Component component;

  const ComponentBreakdown({Key? key, required this.component}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
          color: Colors.black,
        ),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(
        //       Icons.check,
        //       color: Colors.black,
        //     ),
        //     onPressed: () => Navigator.of(context).pop(),
        //   )
        // ],
      ),
      body: const Placeholder(),
    );
  }
}
