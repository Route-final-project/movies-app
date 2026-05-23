import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/resource/colors_manager.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({
    super.key,
    required this.isEnglish,
    required this.onToggle,
  });

  final bool isEnglish;
  final void Function(bool) onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.grey,
        borderRadius: BorderRadius.circular(30.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _FlagButton(flag: '🇺🇸', isSelected: isEnglish, onTap: () => onToggle(true)),
          SizedBox(width: 4.w),
          _FlagButton(flag: '🇪🇬', isSelected: !isEnglish, onTap: () => onToggle(false)),
        ],
      ),
    );
  }
}

class _FlagButton extends StatelessWidget {
  const _FlagButton({
    required this.flag,
    required this.isSelected,
    required this.onTap,
  });

  final String flag;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? ColorsManager.black : Colors.transparent,
        ),
        child: Center(
          child: Text(flag, style: TextStyle(fontSize: 20.sp)),
        ),
      ),
    );
  }
}
