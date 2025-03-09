import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:delcommerce/core/common/view_models/brand_title_with_verification_view_model.dart';
import 'package:delcommerce/core/common/view_models/circular_container_view_model.dart';
import 'package:delcommerce/core/common/view_models/circular_icon_view_model.dart';
import 'package:delcommerce/core/common/view_models/product_price_text_view_model.dart';
import 'package:delcommerce/core/common/view_models/product_title_text_view_model.dart';
import 'package:delcommerce/core/common/view_models/rounded_image_view_model.dart';
import 'package:delcommerce/core/common/widgets/add_to_cart_container.dart';
import 'package:delcommerce/core/common/widgets/brand_title_with_verification.dart';
import 'package:delcommerce/core/common/widgets/circular_container.dart';
import 'package:delcommerce/core/common/widgets/circular_icon.dart';
import 'package:delcommerce/core/common/widgets/product_price_text.dart';
import 'package:delcommerce/core/common/widgets/product_title_text.dart';
import 'package:delcommerce/core/common/widgets/rounded_image.dart';
import 'package:delcommerce/core/common/widgets/sale_tag.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/constants/shadow_styles.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';
import 'package:delcommerce/features/shop/domain/entities/product_entity.dart';
import 'package:delcommerce/features/shop/presentation/views/product_details_view.dart';

class VerticalProductCard extends StatelessWidget {
  const VerticalProductCard({super.key, required this.product});
  final ProductEntity product;
  @override
  Widget build(BuildContext context) {
    final dark = DelHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: () {
        DelHelperFunctions.navigateToScreen(
            context, const ProductDetailsView());
      },
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
            boxShadow: [TShadowStyle.verticalProductCardShadow],
            borderRadius: const BorderRadius.all(
              Radius.circular(DelSizes.productImageRadius),
            ),
            color: dark ? TColors.darkerGrey : TColors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircularContainer(
              circularContainerModel: CircularContainerModel(
                  padding: const EdgeInsets.all(DelSizes.sm),
                  height: 180,
                  color: dark ? TColors.dark : TColors.light,
                  child: Stack(
                    children: [
                      RoundedImage(
                        roundedImageModel: RoundedImageModel(
                            isNetworkImage: true,
                            backgroundColor:
                                dark ? TColors.dark : TColors.light,
                            image: product.images.first,
                            onTap: () {},
                            applyImageRadius: true),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SaleTag(
                            discountPercentage: product.discountPercentage,
                          ),
                          CircularIcon(
                            circularIconModel: CircularIconModel(
                              height: DelSizes.iconLg * 1.2,
                              width: DelSizes.iconLg * 1.2,
                              iconSize: DelSizes.iconMd,
                              icon: Iconsax.heart5,
                              color: Colors.red,
                              backgroundColor:
                                  dark ? TColors.darkerGrey : TColors.white,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
            Padding(
                padding: const EdgeInsets.only(left: DelSizes.sm),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductTitleText(
                        productTitleTextModel: ProductTitleTextModel(
                          title: product.title,
                        ),
                      ),
                      const SizedBox(
                        height: DelSizes.spaceBtwItems / 2,
                      ),
                      BrandTitleWithVerification(
                          brandTitleWithVerificationModel:
                              BrandTitleWithVerificationModel(
                        brandName: product.brand,
                      )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ProductPriceText(
                              productPriceTextModel: ProductPriceTextModel(
                                currencySymbol: "\$",
                                price: product.price.toString(),
                                maxLines: 1,
                                smallSize: true,
                              ),
                            ),
                          ),
                          const AddToCartContainer()
                        ],
                      ),
                    ]))
          ],
        ),
      ),
    );
  }
}
