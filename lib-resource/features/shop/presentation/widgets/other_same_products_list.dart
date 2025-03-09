import 'package:flutter/material.dart';
import 'package:delcommerce/core/common/view_models/rounded_image_view_model.dart';
import 'package:delcommerce/core/common/widgets/rounded_image.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/constants/image_strings.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';

class OtherSameProductsList extends StatelessWidget {
  const OtherSameProductsList({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final dark = DelHelperFunctions.isDarkMode(context);
    return Positioned(
      right: 0,
      bottom: 30,
      left: DelSizes.defaultSpace,
      child: SizedBox(
        height: 80,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => RoundedImage(
                roundedImageModel: RoundedImageModel(
                    image: DelImages.productImage5,
                    width: 80,
                    border: Border.all(
                      color: TColors.primary,
                    ),
                    backgroundColor: dark ? TColors.dark : TColors.white,
                    padding: const EdgeInsets.all(DelSizes.sm))),
            separatorBuilder: (context, index) => const SizedBox(
                  width: DelSizes.spaceBtwItems,
                ),
            itemCount: 6),
      ),
    );
  }
}
