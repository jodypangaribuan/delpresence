//ProductAttributes
import 'package:flutter/material.dart';
import 'package:delcommerce/core/common/view_models/choice_chip_view_model.dart';
import 'package:delcommerce/core/common/view_models/circular_container_view_model.dart';
import 'package:delcommerce/core/common/view_models/product_price_text_view_model.dart';
import 'package:delcommerce/core/common/view_models/product_title_text_view_model.dart';
import 'package:delcommerce/core/common/view_models/section_heading_view_model.dart';
import 'package:delcommerce/core/common/widgets/circular_container.dart';
import 'package:delcommerce/core/common/widgets/custom_choice_chip.dart';
import 'package:delcommerce/core/common/widgets/product_price_text.dart';
import 'package:delcommerce/core/common/widgets/product_title_text.dart';
import 'package:delcommerce/core/common/widgets/section_heading.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';

class ProductAttributes extends StatelessWidget {
  const ProductAttributes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = DelHelperFunctions.isDarkMode(context);
    return Column(
      children: [
        CircularContainer(
          circularContainerModel: CircularContainerModel(
            color: dark ? TColors.darkerGrey : TColors.grey,
            padding: const EdgeInsets.all(DelSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SectionHeading(
                      sectionHeadingModel: SectionHeadingModel(
                        title: 'Variation',
                        showActionButton: false,
                      ),
                    ),
                    const SizedBox(
                      width: DelSizes.spaceBtwItems,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ProductTitleText(
                                productTitleTextModel: ProductTitleTextModel(
                                    title: "Price : ", smallSize: true)),
                            Text(
                              " \$250",
                              style:
                                  Theme.of(context).textTheme.titleSmall!.apply(
                                        decoration: TextDecoration.lineThrough,
                                      ),
                            ),
                            const SizedBox(
                              width: DelSizes.spaceBtwItems,
                            ),
                            ProductPriceText(
                              productPriceTextModel: ProductPriceTextModel(
                                price: "175",
                                smallSize: true,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            ProductTitleText(
                                productTitleTextModel: ProductTitleTextModel(
                                    title: "Stock : ", smallSize: true)),
                            Text("In Stock",
                                style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                ProductTitleText(
                  productTitleTextModel: ProductTitleTextModel(
                    title:
                        "This Is The Description Of The Product And MaxLines Up To Max 4 Lines.",
                    maxLines: 4,
                    smallSize: true,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: DelSizes.spaceBtwItems,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeading(
              sectionHeadingModel: SectionHeadingModel(
                showActionButton: false,
                title: "Colors",
              ),
            ),
            const SizedBox(
              height: DelSizes.spaceBtwItems / 2,
            ),
            Wrap(
              spacing: 8,
              children: [
                CustomChoiceChip(
                  choiceChipModel: ChoiceChipModel(
                    label: "Blue",
                    selected: true,
                    onSelected: (value) {},
                  ),
                ),
                CustomChoiceChip(
                  choiceChipModel: ChoiceChipModel(
                    label: "Yellow",
                    selected: false,
                    onSelected: (value) {},
                  ),
                ),
                CustomChoiceChip(
                  choiceChipModel: ChoiceChipModel(
                    label: "Black",
                    selected: false,
                    onSelected: (value) {},
                  ),
                ),
                CustomChoiceChip(
                  choiceChipModel: ChoiceChipModel(
                    label: "White",
                    selected: false,
                    onSelected: (value) {},
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: DelSizes.spaceBtwItems,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeading(
              sectionHeadingModel: SectionHeadingModel(
                showActionButton: false,
                title: "Sizes",
              ),
            ),
            const SizedBox(
              height: DelSizes.spaceBtwItems / 2,
            ),
            Wrap(
              spacing: 8,
              children: [
                CustomChoiceChip(
                  choiceChipModel: ChoiceChipModel(
                    label: "EU 34",
                    selected: true,
                    onSelected: (value) {},
                  ),
                ),
                CustomChoiceChip(
                  choiceChipModel: ChoiceChipModel(
                    label: "EU 35",
                    selected: false,
                    onSelected: (value) {},
                  ),
                ),
                CustomChoiceChip(
                  choiceChipModel: ChoiceChipModel(
                    label: "EU 36",
                    selected: false,
                    onSelected: (value) {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
