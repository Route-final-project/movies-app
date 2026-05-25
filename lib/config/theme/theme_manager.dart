import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/resource/colors_manager.dart';

abstract class ThemeManager {
  static final ThemeData appTheme = ThemeData(
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: ColorsManager.gold),
      backgroundColor: ColorsManager.black,
      foregroundColor: ColorsManager.gold,
      titleTextStyle: GoogleFonts.roboto(
        color: ColorsManager.white,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
      ),
      centerTitle: true,
    ),
    scaffoldBackgroundColor: ColorsManager.black,
    textTheme: TextTheme(
      titleLarge: GoogleFonts.roboto(
        fontSize: 36.sp,
        fontWeight: FontWeight.w500,
        color: ColorsManager.white,
      ),
      titleMedium: GoogleFonts.roboto(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: ColorsManager.white,
      ),
      titleSmall: GoogleFonts.roboto(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: ColorsManager.white,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 20.sp,
        fontWeight: FontWeight.w400,
        color: ColorsManager.white,
      ),
      bodySmall: GoogleFonts.roboto(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: ColorsManager.white,
      ),
    ),

    colorScheme: ColorScheme.fromSwatch().copyWith(
      brightness: Brightness.dark,
      primary: ColorsManager.gold,
      secondary: ColorsManager.gold,
      surfaceContainer: ColorsManager.grey,
      secondaryContainer: ColorsManager.grey,
    ),

    inputDecorationTheme: InputDecorationTheme(
      hintStyle: GoogleFonts.roboto(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: ColorsManager.white,
      ),
      prefixIconColor: ColorsManager.white,
      suffixIconColor: ColorsManager.white,
      iconColor: ColorsManager.white,
      filled: true,
      fillColor: ColorsManager.grey,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide(color: ColorsManager.grey),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorsManager.red),
        borderRadius: BorderRadius.circular(15.r),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorsManager.red),
        borderRadius: BorderRadius.circular(15.r),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide(color: ColorsManager.grey),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide(color: ColorsManager.grey),
      ),
    ),
    iconTheme: IconThemeData(color: ColorsManager.white, size: 26.sp),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: ColorsManager.gold,
        foregroundColor: ColorsManager.black,
        iconColor: ColorsManager.black,
        iconSize: 26.sp,
        padding: EdgeInsets.all(8.sp),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        textStyle: GoogleFonts.roboto(
          fontSize: 20.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: ColorsManager.grey,
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: ColorsManager.gold, size: 28);
        }

        return const IconThemeData(color: ColorsManager.white, size: 24);
      }),
    ),
    chipTheme: ChipThemeData(
      labelStyle: GoogleFonts.roboto(
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        color: ColorsManager.white,
      ),
      iconTheme: IconThemeData(color: ColorsManager.gold),
      backgroundColor: ColorsManager.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: Colors.transparent),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    ),
  );
}
