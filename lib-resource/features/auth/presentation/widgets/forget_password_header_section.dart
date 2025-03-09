import 'package:flutter/material.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/constants/text_strings.dart';

class ForgetPasswordHeaderSection extends StatelessWidget {
  const ForgetPasswordHeaderSection({
    super.key,
  });
//ForgetPasswordHeader >> forget_password_header.dart
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(DelTexts.forgetPasswordTitle,
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(
          height: DelSizes.spaceBtwItems,
        ),
        Text(DelTexts.forgetPasswordSubTitle,
            style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
