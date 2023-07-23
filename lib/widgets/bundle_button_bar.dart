import 'package:flutter/material.dart';

import 'custom_button.dart';

class BundleButtonBar extends StatelessWidget {
  final VoidCallback? onPressedLeft, onPressedCenter, onPressedRight;

  const BundleButtonBar({
    Key? key,
    required this.onPressedLeft,
    required this.onPressedCenter,
    required this.onPressedRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: CustomButton(
            onPressed: onPressedLeft,
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: CustomButton(
            onPressed: onPressedCenter,
            color: Colors.green,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: CustomButton(
            onPressed: onPressedRight,
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
