

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PrimaryAppButton extends StatelessWidget {
  const PrimaryAppButton({
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
      style: Theme.of(context).filledButtonTheme.style,
      onPressed: onPressed,
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
