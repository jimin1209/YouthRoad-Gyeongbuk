import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class AppScreenContainer extends StatelessWidget {
  const AppScreenContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: AppSpacing.horizontal,
        child: child,
      ),
    );
  }
}
