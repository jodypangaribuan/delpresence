import 'package:flutter/material.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/constants/image_strings.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';

class SignInMethodsSection extends StatelessWidget {
  const SignInMethodsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        decoration: BoxDecoration(
            border: Border.all(color: TColors.grey),
            borderRadius: BorderRadius.circular(100)),
        child: IconButton(
          onPressed: () {},
          icon: const Image(
            height: DelSizes.iconMd,
            width: DelSizes.iconMd,
            image: AssetImage(DelImages.google),
          ),
        ),
      ),
      const SizedBox(
        width: DelSizes.spaceBtwItems,
      ),
      Container(
        decoration: BoxDecoration(
            border: Border.all(color: TColors.grey),
            borderRadius: BorderRadius.circular(100)),
        child: IconButton(
          onPressed: () {},
          icon: const Image(
            height: DelSizes.iconMd,
            width: DelSizes.iconMd,
            image: AssetImage(DelImages.facebook),
          ),
        ),
      ),
    ]);
  }
}
