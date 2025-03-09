import 'package:flutter/material.dart';
import 'package:delcommerce/core/common/view_models/app_bar_view_model.dart';
import 'package:delcommerce/core/common/widgets/app_bar.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/features/shop/presentation/widgets/custom_rating_bar_indicator.dart';
import 'package:delcommerce/features/shop/presentation/widgets/product_overall_rating.dart';
import 'package:delcommerce/features/shop/presentation/widgets/user_review_card.dart';

class ProductReviewsView extends StatelessWidget {
  const ProductReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          appBarModel: AppBarModel(
        hasArrowBack: true,
        title: const Text(
          "Reviews & Ratings",
        ),
      )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(DelSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Ratings and Reviews are verified and from people who have purchased this product.",
                ),
                const SizedBox(
                  height: DelSizes.spaceBtwItems,
                ),
                const ProductOverallRating(),
                const CustomRatingBarIndicator(
                  rating: 4.5,
                ),
                Text("12,611", style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(
                  height: DelSizes.spaceBtwSections,
                ),
                const UserReviewCard(),
                const UserReviewCard(),
                const UserReviewCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
