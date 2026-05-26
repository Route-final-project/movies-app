import 'package:flutter/material.dart';

import '../../../../core/resource/assets_manager.dart';
import '../../../../core/resource/colors_manager.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    required this.avatarId,
    required this.size,
    this.showBorder = false,
    super.key,
  });

  final int avatarId;
  final double size;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final safeIndex = avatarId.clamp(1, ImageAssets.avatars.length) - 1;
    return Container(
      width: size,
      height: size,
      padding: showBorder ? const EdgeInsets.all(2) : EdgeInsets.zero,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(color: ColorsManager.gold, width: 2)
            : null,
      ),
      child: ClipOval(
        child: Image.asset(
          ImageAssets.avatars[safeIndex],
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: ColorsManager.grey,
            child: Icon(
              Icons.person,
              color: ColorsManager.white,
              size: size * .5,
            ),
          ),
        ),
      ),
    );
  }
}
