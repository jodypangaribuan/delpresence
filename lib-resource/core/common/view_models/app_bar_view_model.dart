//app bar Model

import 'package:flutter/material.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';

class AppBarModel {
  final bool centerTitle;
  final bool? hasArrowBack;
  final Widget? title;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  final EdgeInsetsGeometry padding;

  AppBarModel({
    this.padding = const EdgeInsets.symmetric(horizontal: DelSizes.md),
    this.centerTitle = false,
    this.hasArrowBack = false,
    this.title,
    this.leadingIcon,
    this.actions,
    this.leadingOnPressed,
  });
}
