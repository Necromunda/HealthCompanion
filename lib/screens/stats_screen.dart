import 'package:flutter/material.dart';
import 'package:health_companion/widgets/custom_button.dart';
import 'package:health_companion/widgets/loading_components.dart';

class Stats extends StatelessWidget {
  const Stats({Key? key}) : super(key: key);

  void onTap() {
    print("Tap!");
  }

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
      ),
      // body: const Center(child: Text("Stats screen"),),
      body: Center(
        child: CustomButton(
          onPressed: onTap,
          child: const Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),
    );
  }
}
