import 'package:flutter/material.dart';

import '../../../core/core.dart';
import 'login_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 500),
      () => context.pushReplacement(const LoginPage()),
    );
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(80.0),
        child: Center(
          child: Assets.images.logoWhite.image(),
        ),
      ),
    );
  }
}
