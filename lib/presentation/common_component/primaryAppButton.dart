import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/resource/colors_manager.dart';

class PrimaryAppButton extends StatelessWidget {
  const PrimaryAppButton({
    required this.text,
    required this.onPressed,
    this.suffixIcon,
    this.prefixIcon,
    this.isLoading = false,
    this.style,
    super.key,
  });

  final String text;
  final VoidCallback onPressed;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool isLoading;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: ColorsManager.gold),
      );
    }
    return ElevatedButton(
      style: style ?? Theme.of(context).filledButtonTheme.style,
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (prefixIcon != null) ...[
            Padding(
              padding: EdgeInsetsDirectional.only(end: 11.w),
              child: prefixIcon,
            ),
          ],
          Text(text),
          if (suffixIcon != null) ...[
            Padding(
              padding: EdgeInsetsDirectional.only(start: 11.w),
              child: suffixIcon,
            ),
          ],
        ],
      ),
    );
  }
}
