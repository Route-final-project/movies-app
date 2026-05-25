import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../movie_detail_cubit.dart';

class CastMemberCard extends StatelessWidget {
  const CastMemberCard({required this.cast, super.key});

  final CastUiState cast;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .colorScheme
            .secondaryContainer,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(17.r),
            child: CachedNetworkImage(
              imageUrl: cast.imageUrl,
              fit: BoxFit.cover,
              width: 70.w,
              height: 70.h,
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Name: ",
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyMedium,
                    children: [
                      TextSpan(
                        text: cast.name,
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                RichText(
                  text: TextSpan(
                    text: "Character: ",
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyMedium,
                    children: [
                      TextSpan(
                        text: cast.character,
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

