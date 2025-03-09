import 'package:flutter/material.dart';
import 'package:delcommerce/core/common/view_models/circular_container_view_model.dart';
import 'package:delcommerce/core/common/widgets/circular_container.dart';
import 'package:delcommerce/core/common/widgets/read_more.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/constants/image_strings.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';
import 'package:delcommerce/features/shop/presentation/widgets/custom_rating_bar_indicator.dart';

class UserReviewCard extends StatelessWidget {
  const UserReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = DelHelperFunctions.isDarkMode(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage(DelImages.userProfileImage2),
                ),
                const SizedBox(
                  width: DelSizes.spaceBtwItems,
                ),
                Text(
                  "Mahmoud Hamdy",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
          ],
        ),
        const SizedBox(
          width: DelSizes.spaceBtwItems,
        ),
        Row(
          children: [
            const CustomRatingBarIndicator(rating: 4.5),
            const SizedBox(
              width: DelSizes.spaceBtwItems,
            ),
            Text("01 Aug, 2022", style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(
          height: DelSizes.spaceBtwItems,
        ),
        const ReadMore(
          text:
              "mahmoud hamdy fathy elashwah fluttei major to make backword by etoo in pes 6 ",
        ),
        const SizedBox(
          height: DelSizes.spaceBtwItems,
        ),
        CircularContainer(
          circularContainerModel: CircularContainerModel(
            color: dark ? TColors.darkerGrey : TColors.grey,
            child: Padding(
              padding: const EdgeInsets.all(DelSizes.md),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("delcommerce ",
                          style: Theme.of(context).textTheme.titleMedium),
                      Text("02 Aug, 2022",
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  const SizedBox(
                    height: DelSizes.spaceBtwItems,
                  ),
                  const ReadMore(
                    text:
                        "mahmoud hamdy fathy elashwah flutter developer at myself and i major to make backword by etoo in pes 6 ",
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: DelSizes.spaceBtwSections,
        )
      ],
    );
  }
}
