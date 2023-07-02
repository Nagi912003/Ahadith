import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


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
  ),

  textTheme: TextTheme(
    bodyLarge: GoogleFonts.ibmPlexSansArabic(
      color: Colors.white,
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: GoogleFonts.gulzar(
      color: Colors.white,
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: GoogleFonts.tajawal(
      color: Colors.white,
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.rakkas(
      color: Colors.white,
      fontSize: 25.sp,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: GoogleFonts.notoNaskhArabic(
      color: Colors.white,
      fontSize: 26.sp,
      fontWeight: FontWeight.bold,
    ),
  ),

  cardTheme: const CardTheme(
    shadowColor: Colors.white,
    elevation: 0,
  ),
  cardColor: Colors.black45,
);
