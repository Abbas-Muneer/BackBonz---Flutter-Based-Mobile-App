import 'package:flutter/material.dart';

import 'core/theme/app_colors.dart';

class GradientScreen extends StatelessWidget {
  const GradientScreen({
    super.key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
  });

  final PreferredSizeWidget? appBar;
  final Widget child;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.pageGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        floatingActionButton: floatingActionButton,
        body: SafeArea(child: child),
      ),
    );
  }
}
