

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/resource/colors_manager.dart';

class SecondaryAppButton extends StatelessWidget {
  SecondaryAppButton({
    required this.text,
    required this.onPressed,
    this.suffixIcon = const SizedBox(),
    this.prefixIcon = const SizedBox(),
    super.key});

  final String text;
  final VoidCallback onPressed;
  final Widget suffixIcon;
  final Widget prefixIcon;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: Theme.of(context).filledButtonTheme.style?.copyWith(
        backgroundColor: WidgetStatePropertyAll(ColorsManager.red),
        foregroundColor: WidgetStatePropertyAll(ColorsManager.white),
        iconColor: WidgetStatePropertyAll(ColorsManager.white),
      ),
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 11.w),
            child: prefixIcon,
          ),
          Text(text),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 11.w),
            child: suffixIcon,
          ),
        ],
      ),
    );
  }
}

