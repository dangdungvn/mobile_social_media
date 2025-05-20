import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobile/common/utils/app_colors.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CircleAvatar extends StatelessWidget {
  final String imageUrl;
  final double? radius;
  final bool isOnline;
  final bool hasBorder;

  const CircleAvatar({
    super.key,
    required this.imageUrl,
    this.radius,
    this.isOnline = false,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final calculatedRadius = radius ?? 24.r;

    return Stack(
      children: [
        Container(
          width: calculatedRadius * 2,
          height: calculatedRadius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                hasBorder
                    ? Border.all(
                      color:
                          isDarkMode
                              ? AppColors.primaryDark
                              : AppColors.primaryLight,
                      width: 2,
                    )
                    : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(calculatedRadius),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Shimmer.fromColors(
                    baseColor:
                        isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                    highlightColor:
                        isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
                    child: Container(color: Colors.grey),
                  ),
              errorWidget:
                  (context, url, error) => Container(
                    color:
                        isDarkMode ? AppColors.cardDark : AppColors.cardLight,
                    child: Icon(
                      Icons.person,
                      size: calculatedRadius,
                      color:
                          isDarkMode
                              ? AppColors.textLightDark
                              : AppColors.textLightLight,
                    ),
                  ),
            ),
          ),
        ),
        if (isOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: (calculatedRadius / 2.5).r,
              height: (calculatedRadius / 2.5).r,
              decoration: BoxDecoration(
                color: AppColors.online,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDarkMode ? AppColors.cardDark : AppColors.white,
                  width: 1.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
