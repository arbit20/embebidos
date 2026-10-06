import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class Tarjeta extends StatelessWidget {
  const Tarjeta({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borde),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
