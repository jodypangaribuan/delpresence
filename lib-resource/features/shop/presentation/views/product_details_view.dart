import 'package:flutter/material.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/features/shop/presentation/widgets/bottom_add_to_cart.dart';
import 'package:delcommerce/features/shop/presentation/widgets/checkout_button.dart';
import 'package:delcommerce/features/shop/presentation/widgets/product_attributes.dart';
import 'package:delcommerce/features/shop/presentation/widgets/product_description_section.dart';
import 'package:delcommerce/features/shop/presentation/widgets/product_image_slider.dart';
import 'package:delcommerce/features/shop/presentation/widgets/product_metadata.dart';
import 'package:delcommerce/features/shop/presentation/widgets/rating_and_share.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        bottomNavigationBar: BottomAddToCart(),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
            children: [
              ProducDelImageslider(),
              Padding(
                padding: EdgeInsets.fromLTRB(DelSizes.defaultSpace, 0,
                    DelSizes.defaultSpace, DelSizes.defaultSpace),
                child: Column(
                  children: [
                    RatingAndShare(),
                    ProductMetadata(),
                    ProductAttributes(),
                    SizedBox(
                      height: DelSizes.spaceBtwSections,
                    ),
                    CheckoutButton(),
                    SizedBox(
                      height: DelSizes.spaceBtwSections,
                    ),
                    ProductDescriptionAndReviewsSection(),
                    SizedBox(height: DelSizes.spaceBtwSections),
                  ],
                ),
              )
            ],
          )),
        ));
  }
}
