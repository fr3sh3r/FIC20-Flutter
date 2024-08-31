import 'package:flutter/material.dart';
import 'package:flutter_hrm_inventory_pos_app/data/datasources/auth_local_datasource.dart';

import '../../../core/core.dart';
import '../../home/pages/main_page.dart';
import 'login_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: FutureBuilder<bool>(
        future: Future.delayed(const Duration(seconds: 2),
            () => AuthLocalDatasource().isUserLoggedIn()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.all(80.0),
              child: Center(
                child: Assets.images.logoWhite.image(),
              ),
            );
          } else if (snapshot.hasData && snapshot.data == true) {
            return const MainPage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
