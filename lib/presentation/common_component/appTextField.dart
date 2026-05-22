import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/resource/colors_manager.dart';

class AppTextField extends StatelessWidget {
  AppTextField({
    this.onTap,
    this.focusNode,
    this.suffixIcon,
    this.controller,
    required this.prefixIcon,
    this.obscureText = false,
    required this.hintText,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.onChanged,
    this.onSuffixClicked,
    super.key,
  });

  final TextEditingController? controller;

  final Widget? suffixIcon;
  final void Function()? onSuffixClicked;
  final Widget prefixIcon;
  final bool obscureText;
  final String hintText;
  final String? Function(String? value) validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int maxLines;
  final FocusNode? focusNode;
  final void Function(String value)? onChanged;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onTap: onTap,
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
        prefixIconConstraints: BoxConstraints(minWidth: 20.w, minHeight: 20.h),
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(onTap: onSuffixClicked, child: suffixIcon),
              )
            : null,
      ),
    );
  }
}
