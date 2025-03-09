import 'package:flutter/material.dart';
import 'package:delcommerce/core/common/view_models/product_price_text_view_model.dart';
import 'package:delcommerce/core/common/widgets/product_price_text.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/features/shop/presentation/widgets/cart_item.dart';
import 'package:delcommerce/features/shop/presentation/widgets/product_quantity_with_add_and_remove_buttons.dart';

class CartItemsList extends StatelessWidget {
  const CartItemsList({
    super.key,
    this.showAddRemoveButtons = true,
  });
  final bool showAddRemoveButtons;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Column(
            children: [
              const CartItem(),
              if (showAddRemoveButtons)
                const SizedBox(
                  height: DelSizes.spaceBtwItems,
                ),
              if (showAddRemoveButtons)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        SizedBox(
                          width: 70,
                        ),
                        ProductQuantityWithAddAndRemoveButtons(),
                      ],
                    ),
                    ProductPriceText(
                        productPriceTextModel: ProductPriceTextModel(
                            price: "175", smallSize: true)),
                  ],
                )
            ],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
              height: DelSizes.spaceBtwSections,
            ),
        itemCount: 5);
  }
}
