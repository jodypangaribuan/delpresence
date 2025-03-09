//Section Heading Model >>
import 'package:flutter/material.dart';
import 'package:delcommerce/core/utils/constants/text_strings.dart';

class SectionHeadingModel {
  final Color? textColor;
  final bool showActionButton;
  final String title, actionButtonTitle;
  final Function()? actionButtonOnPressed;

  SectionHeadingModel(
      {this.textColor,
      this.showActionButton = true,
      required this.title,
      this.actionButtonTitle = DelTexts.viewAll,
      this.actionButtonOnPressed});
}
