import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:delcommerce/core/common/view_models/circular_icon_view_model.dart';
import 'package:delcommerce/core/common/widgets/circular_icon.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';

class ProductQuantityWithAddAndRemoveButtons extends StatelessWidget {
  const ProductQuantityWithAddAndRemoveButtons({
    super.key,
  });
//ProductQuantityWithAddAndRemoveButtons >>
  @override
  Widget build(BuildContext context) {
    final dark = DelHelperFunctions.isDarkMode(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularIcon(
          circularIconModel: CircularIconModel(
            icon: Iconsax.minus,
            width: 32,
            height: 32,
            iconSize: DelSizes.md,
            color: dark ? TColors.white : TColors.dark,
            backgroundColor: dark ? TColors.darkerGrey : TColors.light,
          ),
        ),
        const SizedBox(
          width: DelSizes.spaceBtwItems,
        ),
        Text(
          "2",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          width: DelSizes.spaceBtwItems,
        ),
        CircularIcon(
          circularIconModel: CircularIconModel(
            icon: Iconsax.add,
            width: 32,
            height: 32,
            iconSize: DelSizes.md,
            color: TColors.white,
            backgroundColor: TColors.primary,
          ),
        ),
      ],
    );
  }
}
