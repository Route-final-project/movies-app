import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/resource/colors_manager.dart';

class SecondaryAppButton extends StatelessWidget {
  const SecondaryAppButton({
    required this.text,
    required this.onPressed,
    this.suffixIcon,
    this.prefixIcon,
    super.key,
  });

  final String text;
  final VoidCallback onPressed;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: Theme.of(context).filledButtonTheme.style?.copyWith(
        backgroundColor: WidgetStatePropertyAll(ColorsManager.red),
        foregroundColor: WidgetStatePropertyAll(ColorsManager.white),
        iconColor: WidgetStatePropertyAll(ColorsManager.white),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixIcon != null) ...[
              Padding(
                padding: EdgeInsetsDirectional.only(end: 11.w),
                child: prefixIcon,
              ),
            ],
            Text(text, style: Theme.of(context).textTheme.titleSmall),
            if (suffixIcon != null) ...[
              Padding(
                padding: EdgeInsetsDirectional.only(start: 11.w),
                child: suffixIcon,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

