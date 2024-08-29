import 'package:flutter/material.dart';
import 'package:flutter_hrm_inventory_pos_app/presentation/auth/pages/splash_page.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/constants/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EDIM HRM Inventory POS App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
        dialogBackgroundColor: AppColors.white,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.white,
        ),
        bottomSheetTheme:
            const BottomSheetThemeData(backgroundColor: AppColors.white),
        dividerTheme: const DividerThemeData(color: AppColors.stroke),
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: AppBarTheme(
          color: AppColors.white,
          elevation: 0,
          titleTextStyle: GoogleFonts.inter(
            color: AppColors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
          iconTheme: const IconThemeData(
            color: AppColors.black,
          ),
          centerTitle: true,
        ),
        listTileTheme: const ListTileThemeData(
          titleTextStyle: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
      ), //themedata
      home: const SplashPage(),
    );
  }
}
