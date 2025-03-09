import 'package:flutter/material.dart';
import 'package:delcommerce/core/common/view_models/brand_title_with_verification_view_model.dart';
import 'package:delcommerce/core/common/view_models/product_price_text_view_model.dart';
import 'package:delcommerce/core/common/view_models/product_title_text_view_model.dart';
import 'package:delcommerce/core/common/view_models/rounded_image_view_model.dart';
import 'package:delcommerce/core/common/widgets/brand_title_with_verification.dart';
import 'package:delcommerce/core/common/widgets/product_price_text.dart';
import 'package:delcommerce/core/common/widgets/product_title_text.dart';
import 'package:delcommerce/core/common/widgets/rounded_image.dart';
import 'package:delcommerce/core/common/widgets/sale_tag.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/constants/image_strings.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';

class ProductMetadata extends StatelessWidget {
  const ProductMetadata({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = DelHelperFunctions.isDarkMode(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          const SaleTag(
            discountPercentage: 44,
          ),
          const SizedBox(
            width: DelSizes.spaceBtwItems,
          ),
          Text(
            " \$250",
            style: Theme.of(context).textTheme.titleSmall!.apply(
                  decoration: TextDecoration.lineThrough,
                ),
          ),
          const SizedBox(
            width: DelSizes.spaceBtwItems,
          ),
          ProductPriceText(
              productPriceTextModel: ProductPriceTextModel(
            price: "175",
            smallSize: false,
          ))
        ],
      ),
      const SizedBox(
        height: DelSizes.spaceBtwItems / 1.5,
      ),
      ProductTitleText(
          productTitleTextModel: ProductTitleTextModel(
        title: "Green Nike Sports Jacket",
      )),
      const SizedBox(
        height: DelSizes.spaceBtwItems / 1.5,
      ),
      Row(
        children: [
          ProductTitleText(
              productTitleTextModel: ProductTitleTextModel(
            title: "Status",
          )),
          const SizedBox(
            width: DelSizes.spaceBtwItems,
          ),
          Text("In Stock", style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
      const SizedBox(
        height: DelSizes.spaceBtwItems / 1.5,
      ),
      Row(
        children: [
          RoundedImage(
            roundedImageModel: RoundedImageModel(
              image: DelImages.nikeLogo,
              width: 32,
              height: 32,
              backgroundColor: dark ? TColors.black : TColors.white,
              overlayColor: dark ? TColors.white : TColors.black,
            ),
          ),
          const BrandTitleWithVerification(
            brandTitleWithVerificationModel:
                BrandTitleWithVerificationModel(brandName: "Nike"),
          ),
        ],
      ),
    ]);
  }
}
