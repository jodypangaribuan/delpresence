import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/constants/text_strings.dart';

class SearchContainerModel {
  final IconData? icon;
  final String title;
  final bool showBackground, showBorder;
  final void Function()? onPressed;
  final EdgeInsetsGeometry padding;
  SearchContainerModel({
    this.padding =
        const EdgeInsets.symmetric(horizontal: DelSizes.defaultSpace),
    this.onPressed,
    this.icon = Iconsax.search_normal,
    this.title = DelTexts.searchContainer,
    this.showBackground = true,
    this.showBorder = true,
  });
}
