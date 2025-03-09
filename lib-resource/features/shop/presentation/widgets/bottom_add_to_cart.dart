import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:delcommerce/core/common/view_models/circular_icon_view_model.dart';
import 'package:delcommerce/core/common/widgets/circular_icon.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';

class BottomAddToCart extends StatelessWidget {
  const BottomAddToCart({super.key});
  @override
  Widget build(BuildContext context) {
    final dark = DelHelperFunctions.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.all(DelSizes.defaultSpace),
      decoration: BoxDecoration(
        color: dark ? TColors.darkGrey : TColors.light,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(DelSizes.cardRadiusLg),
          topRight: Radius.circular(DelSizes.cardRadiusLg),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircularIcon(
                circularIconModel: CircularIconModel(
                    icon: Iconsax.minus,
                    height: 40,
                    width: 40,
                    color: TColors.white,
                    backgroundColor: TColors.darkerGrey,
                    onPressed: () {}),
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
                    height: 40,
                    width: 40,
                    color: TColors.white,
                    backgroundColor: TColors.black,
                    onPressed: () {}),
              ),
              const SizedBox(
                width: DelSizes.spaceBtwItems,
              ),
            ],
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(DelSizes.md),
                backgroundColor: TColors.black,
                side: const BorderSide(color: TColors.black),
              ),
              onPressed: () {},
              child: const Text("Add To Cart")),
        ],
      ),
    );
  }
}
