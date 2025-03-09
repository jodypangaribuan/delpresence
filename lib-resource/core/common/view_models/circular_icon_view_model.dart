import 'package:flutter/material.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';

class CircularIconModel {
  final Color? color;
  final IconData icon;
  final VoidCallback? onPressed;
  final double? iconSize;
  final double? height;
  final double? width;
  final Color? backgroundColor;

  CircularIconModel({
    this.color,
    required this.icon,
    this.onPressed,
    this.iconSize = DelSizes.lg,
    this.height,
    this.width,
    this.backgroundColor,
  });
}
