import 'package:flutter/material.dart';
import 'package:delcommerce/core/common/view_models/brand_card_view_model.dart';
import 'package:delcommerce/core/common/view_models/brand_showcase_view_model.dart';
import 'package:delcommerce/core/common/view_models/circular_container_view_model.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';
import 'package:delcommerce/core/common/widgets/brand_card.dart';
import 'package:delcommerce/core/common/widgets/circular_container.dart';

class BrandShowcase extends StatelessWidget {
  const BrandShowcase(
    this.brandShowcaseModel, {
    super.key,
  });

  final BrandShowcaseModel brandShowcaseModel;

  @override
  Widget build(BuildContext context) {
    final brandIcon = brandShowcaseModel.brandCardModel.image;
    final brandTitle = brandShowcaseModel.brandCardModel.brandName;
    final products = brandShowcaseModel.topThreeProductsOfBrand;
    return Column(
      children: [
        CircularContainer(
            circularContainerModel: CircularContainerModel(
                color: Colors.transparent,
                borderColor: TColors.darkGrey,
                padding: const EdgeInsets.all(DelSizes.md),
                margin: const EdgeInsets.only(bottom: DelSizes.spaceBtwItems),
                showBorder: true,
                child: Column(
                  children: [
                    BrandCard(
                      brandCardModel: BrandCardModel(
                          showBorder: false,
                          productCount: 5,
                          image: brandIcon,
                          brandName: brandTitle),
                    ),
                    Row(
                      children: products
                          .map((product) =>
                              brandTopProductsWidget(context, product))
                          .toList(),
                    ),
                  ],
                )))
      ],
    );
  }

  Expanded brandTopProductsWidget(BuildContext context, String product) {
    final dark = DelHelperFunctions.isDarkMode(context);
    return Expanded(
      child: CircularContainer(
        circularContainerModel: CircularContainerModel(
            padding: const EdgeInsets.all(DelSizes.md),
            margin: const EdgeInsets.only(right: DelSizes.sm),
            height: 100,
            color: dark ? TColors.darkerGrey : TColors.light,
            child: Image(
              image: AssetImage(
                product,
              ),
              fit: BoxFit.contain,
            )),
      ),
    );
  }
}
