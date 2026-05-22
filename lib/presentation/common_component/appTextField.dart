
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/resource/colors_manager.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    this.suffixIcon,
    required this.prefixIcon,
    this.obscureText = false,
    required this.hintText,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.onChanged,
    this.onSuffixClicked,
    this.controller,
    super.key,
  });

  final Widget? suffixIcon;
  final void Function()? onSuffixClicked;
  final Widget prefixIcon;
  final bool obscureText;
  final String hintText;
  final String? Function(String? value) validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int maxLines;
  final void Function(String value)? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLines,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      cursorColor: ColorsManager.white,
      style: Theme.of(context).textTheme.bodySmall,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.all(8.sp),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: prefixIcon,
        ),
        suffixIcon: suffixIcon != null
            ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
              onTap: onSuffixClicked,
              child: suffixIcon),
        )
            : null,
      ),
    );
  }
}
