import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';

class ProductShimmer extends StatelessWidget {
  const ProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = DelHelperFunctions.isDarkMode(context);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: DelSizes.gridViewSpacing,
        crossAxisSpacing: DelSizes.gridViewSpacing,
        mainAxisExtent: 288,
      ),
      itemCount: 4, // Show 4 shimmer items while loading
      itemBuilder: (_, __) => Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DelSizes.productImageRadius),
          color: dark ? TColors.darkerGrey : TColors.white,
        ),
        child: Shimmer.fromColors(
          baseColor: dark ? Colors.grey[850]! : Colors.grey[300]!,
          highlightColor: dark ? Colors.grey[700]! : Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image container shimmer
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(DelSizes.productImageRadius),
                ),
              ),
              const SizedBox(height: DelSizes.spaceBtwItems),
              // Title shimmer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: DelSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 12,
                      color: Colors.white,
                    ),
                    const SizedBox(height: DelSizes.spaceBtwItems / 2),
                    // Brand shimmer
                    Container(
                      width: 100,
                      height: 10,
                      color: Colors.white,
                    ),
                    const SizedBox(height: DelSizes.spaceBtwItems),
                    // Price and cart button shimmer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 60,
                          height: 15,
                          color: Colors.white,
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
