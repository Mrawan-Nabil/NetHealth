import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';

class NhAvatar extends StatelessWidget {
  final String? imageUrl;
  final String fallbackName;
  final double radius;
  final VoidCallback? onEditTap;

  const NhAvatar({
    super.key,
    this.imageUrl,
    required this.fallbackName,
    this.radius = 40,
    this.onEditTap,
  });

  String get _initials {
    final parts = fallbackName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fallbackName.isNotEmpty ? fallbackName[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: AppColors.primaryFaint,
          child: imageUrl != null
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!,
                    width: radius * 2,
                    height: radius * 2,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => _buildInitials(),
                    errorWidget: (_, __, ___) => _buildInitials(),
                  ),
                )
              : _buildInitials(),
        ),
        if (onEditTap != null)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEditTap,
              child: Container(
                width: radius * 0.65,
                height: radius * 0.65,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: radius * 0.35,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInitials() => Text(
        _initials,
        style: TextStyle(
          fontSize: radius * 0.45,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      );
}
