import 'package:ahadith/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeManager _themeManager = ThemeManager();

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black12,
    foregroundColor: Colors.deepPurple.shade100,
    titleTextStyle: GoogleFonts.kufam(
      color: Colors.white,
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
    ),
// titleTextStyle: GoogleFonts.gulzar(
//   color: Colors.white,
//   fontSize: 20.sp,
//   fontWeight: FontWeight.bold,
// ),
  ),

  textTheme: TextTheme(
    bodyLarge: GoogleFonts.kufam(
      color: Colors.white,
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: GoogleFonts.gulzar(
      color: Colors.white,
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: GoogleFonts.amiri(
      color: Colors.white,
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.rakkas(
      color: Colors.white,
      fontSize: 25.sp,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: GoogleFonts.lateef(
      color: Colors.white,
      fontSize: 26.sp,
      fontWeight: FontWeight.bold,
    ),
  ),
// textTheme: TextTheme(
//   bodyLarge: GoogleFonts.gulzar(
//     color: Colors.white,
//     fontSize: 18.sp,
//     fontWeight: FontWeight.bold,
//   ),
//   bodyMedium: GoogleFonts.gulzar(
//     color: Colors.white,
//     fontSize: 16.sp,
//     fontWeight: FontWeight.bold,
//   ),
//   bodySmall: GoogleFonts.amiri(
//     color: Colors.white,
//     fontSize: 20.sp,
//     fontWeight: FontWeight.bold,
//   ),
//   titleLarge: GoogleFonts.rakkas(
//     color: Colors.white,
//     fontSize: 25.sp,
//     fontWeight: FontWeight.bold,
//   ),
// ),

  cardTheme: const CardTheme(
    shadowColor: Colors.white,
    elevation: 0,
  ),
  cardColor: Colors.black45,
);

// theme: ThemeData(
// primaryColor: Colors.blue,
// brightness: Brightness.light,
// //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
// useMaterial3: true,
//
// appBarTheme: AppBarTheme(
// backgroundColor: Colors.white,
// foregroundColor: Theme.of(context).primaryColor,
// // titleTextStyle: GoogleFonts.gulzar(
// //   color: Colors.black87,
// //   fontSize: 20.sp,
// //   fontWeight: FontWeight.bold,
// // ),
// titleTextStyle: GoogleFonts.kufam(
// color: Colors.black87,
// fontSize: 20.sp,
// fontWeight: FontWeight.bold,
// ),
// ),
//
// textTheme: TextTheme(
// bodyLarge: GoogleFonts.kufam(
// color: Colors.black87,
// fontSize: 18.sp,
// fontWeight: FontWeight.bold,
// ),
// bodyMedium: GoogleFonts.kufam(
// color: Colors.black87,
// fontSize: 16.sp,
// fontWeight: FontWeight.bold,
// ),
// bodySmall: GoogleFonts.kufam(
// color: Colors.grey[800],
// fontSize: 20.sp,
// fontWeight: FontWeight.bold,
// ),
// titleLarge: GoogleFonts.rakkas(
// color: Colors.deepPurple,
// fontSize: 25.sp,
// fontWeight: FontWeight.bold,
// ),
// displaySmall: GoogleFonts.lateef(
// color: Colors.black87,
// fontSize: 18.sp,
// fontWeight: FontWeight.bold,
// ),
// ),
// // textTheme: TextTheme(
// //   bodyLarge: GoogleFonts.gulzar(
// //     color: Colors.black87,
// //     fontSize: 18.sp,
// //     fontWeight: FontWeight.bold,
// //   ),
// //   bodyMedium: GoogleFonts.gulzar(
// //     color: Colors.black87,
// //     fontSize: 16.sp,
// //     fontWeight: FontWeight.bold,
// //   ),
// //   bodySmall: GoogleFonts.amiri(
// //     color: Colors.black87,
// //     fontSize: 20.sp,
// //     fontWeight: FontWeight.bold,
// //   ),
// //   titleLarge: GoogleFonts.rakkas(
// //     color: Colors.black87,
// //     fontSize: 25.sp,
// //     fontWeight: FontWeight.bold,
// //   ),
// // ),
//
// cardTheme: const CardTheme(
// shadowColor: Colors.black,
// elevation: 0,
// ),
// cardColor: Colors.grey[100],
// ),
//
// darkTheme: ThemeData(
// useMaterial3: true,
// brightness: Brightness.dark,
// appBarTheme: AppBarTheme(
// backgroundColor: Colors.black12,
// foregroundColor: Colors.deepPurple.shade100,
// titleTextStyle: GoogleFonts.kufam(
// color: Colors.white,
// fontSize: 20.sp,
// fontWeight: FontWeight.bold,
// ),
// // titleTextStyle: GoogleFonts.gulzar(
// //   color: Colors.white,
// //   fontSize: 20.sp,
// //   fontWeight: FontWeight.bold,
// // ),
// ),
//
// textTheme: TextTheme(
// bodyLarge: GoogleFonts.kufam(
// color: Colors.white,
// fontSize: 18.sp,
// fontWeight: FontWeight.bold,
// ),
// bodyMedium: GoogleFonts.gulzar(
// color: Colors.white,
// fontSize: 16.sp,
// fontWeight: FontWeight.bold,
// ),
// bodySmall: GoogleFonts.amiri(
// color: Colors.white,
// fontSize: 20.sp,
// fontWeight: FontWeight.bold,
// ),
// titleLarge: GoogleFonts.rakkas(
// color: Colors.white,
// fontSize: 25.sp,
// fontWeight: FontWeight.bold,
// ),
// displaySmall: GoogleFonts.lateef(
// color: Colors.white,
// fontSize: 26.sp,
// fontWeight: FontWeight.bold,
// ),
// ),
// // textTheme: TextTheme(
// //   bodyLarge: GoogleFonts.gulzar(
// //     color: Colors.white,
// //     fontSize: 18.sp,
// //     fontWeight: FontWeight.bold,
// //   ),
// //   bodyMedium: GoogleFonts.gulzar(
// //     color: Colors.white,
// //     fontSize: 16.sp,
// //     fontWeight: FontWeight.bold,
// //   ),
// //   bodySmall: GoogleFonts.amiri(
// //     color: Colors.white,
// //     fontSize: 20.sp,
// //     fontWeight: FontWeight.bold,
// //   ),
// //   titleLarge: GoogleFonts.rakkas(
// //     color: Colors.white,
// //     fontSize: 25.sp,
// //     fontWeight: FontWeight.bold,
// //   ),
// // ),
//
// cardTheme: const CardTheme(
// shadowColor: Colors.white,
// elevation: 0,
// ),
// cardColor: Colors.black45,
// ),
//
// themeMode: ThemeMode.system,
