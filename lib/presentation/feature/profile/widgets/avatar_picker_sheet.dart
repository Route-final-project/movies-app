import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/resource/colors_manager.dart';
import 'profile_avatar.dart';

class AvatarPickerSheet extends StatelessWidget {
  const AvatarPickerSheet({
    required this.selectedAvatarId,
    required this.onSelected,
    super.key,
  });

  final int selectedAvatarId;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(17.w, 16.h, 17.w, 20.h),
      decoration: BoxDecoration(
        color: ColorsManager.grey,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: 9,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 1.18,
        ),
        itemBuilder: (context, index) {
          final avatarId = index + 1;
          final selected = avatarId == selectedAvatarId;
          return InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: () => onSelected(avatarId),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: EdgeInsets.all(5.r),
              decoration: BoxDecoration(
                color: selected
                    ? ColorsManager.gold.withValues(alpha: .25)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: ColorsManager.gold,
                  width: selected ? 2 : 1,
                ),
              ),
              child: Center(
                child: ProfileAvatar(avatarId: avatarId, size: 67.r),
              ),
            ),
          );
        },
      ),
    );
  }
}
