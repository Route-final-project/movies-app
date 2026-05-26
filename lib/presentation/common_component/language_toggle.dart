import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/resource/colors_manager.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({
    required this.isEnglish,
    required this.onToggle,
    super.key,
  });

  final bool isEnglish;
  final void Function(bool) onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.grey,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: ColorsManager.gold.withValues(alpha: .35),
          width: 1.r,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .18),
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      padding: EdgeInsets.all(4.r),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _FlagButton(
            flag: '\u{1F1FA}\u{1F1F8}',
            isSelected: isEnglish,
            onTap: () => onToggle(true),
          ),
          SizedBox(width: 6.w),
          _FlagButton(
            flag: '\u{1F1EA}\u{1F1EC}',
            isSelected: !isEnglish,
            onTap: () => onToggle(false),
          ),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: 42.w,
        height: 34.h,
        decoration: BoxDecoration(
          color: isSelected ? ColorsManager.black : Colors.transparent,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: isSelected ? ColorsManager.gold : Colors.transparent,
            width: 1.5.r,
          ),
        ),
        child: Center(
          child: Text(flag, style: TextStyle(fontSize: 22.sp, height: 1)),
        ),
      ),
    );
  }
}
