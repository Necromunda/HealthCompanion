import 'package:flutter/material.dart';

import 'package:health_companion/util.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final double? width, height;
  final Color? color, borderColor;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.width,
    this.height,
    this.color,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width ?? 65,
        height: height ?? 40,
        decoration: BoxDecoration(
          color: color ??
              (onPressed == null
                  ? Colors.grey
                  : Util.isDark(context)
                      ? Theme.of(context).colorScheme.onTertiary
                      : Theme.of(context).colorScheme.tertiary),
          border: Border.all(
            color: Colors.transparent,
            width: 1,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(3),
          ),
        ),
        child: child,
      ),
    );
  }
}
