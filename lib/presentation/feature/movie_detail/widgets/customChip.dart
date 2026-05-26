
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomChip extends StatelessWidget {
  const CustomChip({
    required this.value,
    required this.svgIconAsset,
    super.key,
  });

  final String value;
  final String svgIconAsset;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: SvgPicture.asset(svgIconAsset),
      label: Text(value),
    );
  }
}
