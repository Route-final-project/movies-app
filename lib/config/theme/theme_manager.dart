import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/resource/colors_manager.dart';

abstract class ThemeManager{
  static final ThemeData light = ThemeData(
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: ColorsManager.white),
      backgroundColor: ColorsManager.black,
      foregroundColor: ColorsManager.white,
      titleTextStyle:GoogleFonts.inter(color: ColorsManager.white, fontSize: 20.sp,fontWeight: FontWeight.w500 ),
centerTitle: true,
    ),
    scaffoldBackgroundColor: ColorsManager.black,
 drawerTheme: DrawerThemeData(
   backgroundColor: ColorsManager.black
 ),
    textTheme: TextTheme(
      titleMedium: GoogleFonts.inter(fontSize: 24.sp, fontWeight: FontWeight.bold, color: ColorsManager.white)
    )
  );
  static final ThemeData dark = ThemeData();
}