import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/resource/assets_manager.dart';
import '../../../../core/resource/colors_manager.dart';
import '../../../common_component/appTextField.dart';
import '../../../common_component/primaryAppButton.dart';
import '../../../common_component/language_toggle.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    required this.child,
    this.title,
    this.showBack = false,
    super.key,
  });

  final Widget child;
  final String? title;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title == null
          ? null
          : AppBar(
              toolbarHeight: 56.h,
              title: Text(
                title!,
                style: GoogleFonts.roboto(
                  color: ColorsManager.gold,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              leading: showBack
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: ColorsManager.gold,
                        size: 28.r,
                      ),
                      onPressed: () => Navigator.pop(context),
                    )
                  : null,
              backgroundColor: ColorsManager.black,
              elevation: 0,
              centerTitle: true,
            ),
      body: SafeArea(child: child),
    );
  }
}

class AuthField extends StatelessWidget {
  const AuthField({
    required this.controller,
    required this.prefixIcon,
    required this.hintText,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.onSuffixClicked,
    super.key,
  });

  final TextEditingController controller;
  final Widget prefixIcon;
  final String hintText;
  final String? Function(String?) validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixClicked;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54.h,
      child: Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.copyWith(
            bodySmall: GoogleFonts.roboto(
              color: ColorsManager.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
            hintStyle: GoogleFonts.roboto(
              color: ColorsManager.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 14.h),
            filled: true,
            fillColor: ColorsManager.grey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        child: AppTextField(
          controller: controller,
          prefixIcon: IconTheme(
            data: IconThemeData(color: ColorsManager.white, size: 24.r),
            child: prefixIcon,
          ),
          suffixIcon: suffixIcon == null
              ? null
              : IconTheme(
                  data: IconThemeData(color: ColorsManager.white, size: 24.r),
                  child: suffixIcon!,
                ),
          hintText: hintText,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          onSuffixClicked: onSuffixClicked,
        ),
      ),
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: ColorsManager.gold),
            )
          : Theme(
              data: Theme.of(context).copyWith(
                filledButtonTheme: FilledButtonThemeData(
                  style: FilledButton.styleFrom(
                    backgroundColor: ColorsManager.gold,
                    foregroundColor: ColorsManager.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    textStyle: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              child: PrimaryAppButton(text: text, onPressed: onPressed),
            ),
    );
  }
}

class AuthGoogleButton extends StatelessWidget {
  const AuthGoogleButton({
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: ColorsManager.gold),
            )
          : Theme(
              data: Theme.of(context).copyWith(
                filledButtonTheme: FilledButtonThemeData(
                  style: FilledButton.styleFrom(
                    backgroundColor: ColorsManager.gold,
                    foregroundColor: ColorsManager.black,
                    iconColor: ColorsManager.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    textStyle: GoogleFonts.roboto(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              child: PrimaryAppButton(
                text: 'Login With Google',
                onPressed: onPressed,
                prefixIcon: SvgPicture.asset(
                  ImageAssets.googleIcon,
                  width: 24.r,
                  height: 24.r,
                  colorFilter: const ColorFilter.mode(
                    ColorsManager.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
    );
  }
}

class AuthLanguageToggle extends StatelessWidget {
  const AuthLanguageToggle({
    required this.isEnglish,
    required this.onToggle,
    super.key,
  });

  final bool isEnglish;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1,
      child: LanguageToggle(isEnglish: isEnglish, onToggle: onToggle),
    );
  }
}

class AuthLinkText extends StatelessWidget {
  const AuthLinkText({
    required this.prefix,
    required this.action,
    required this.onTap,
    super.key,
  });

  final String prefix;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          text: prefix,
          style: GoogleFonts.roboto(
            color: ColorsManager.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          children: [
            TextSpan(
              text: action,
              style: GoogleFonts.roboto(
                color: ColorsManager.gold,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
