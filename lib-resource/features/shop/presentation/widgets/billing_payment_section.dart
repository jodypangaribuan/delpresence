import 'package:flutter/material.dart';
import 'package:delcommerce/core/common/view_models/circular_container_view_model.dart';
import 'package:delcommerce/core/common/view_models/section_heading_view_model.dart';
import 'package:delcommerce/core/common/widgets/circular_container.dart';
import 'package:delcommerce/core/common/widgets/section_heading.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/constants/image_strings.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';

class BillingPaymentSection extends StatelessWidget {
  const BillingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = DelHelperFunctions.isDarkMode(context);
    return Column(
      children: [
        SectionHeading(
          sectionHeadingModel: SectionHeadingModel(
            title: "Payment Method",
            actionButtonOnPressed: () {},
            showActionButton: true,
            actionButtonTitle: "Change",
          ),
        ),
        const SizedBox(
          height: DelSizes.spaceBtwItems / 2,
        ),
        Row(
          children: [
            CircularContainer(
              circularContainerModel: CircularContainerModel(
                width: 60,
                height: 35,
                color: dark ? TColors.light : TColors.white,
                padding: const EdgeInsets.all(DelSizes.sm),
                child: const Image(
                    image: AssetImage(DelImages.paypal), fit: BoxFit.contain),
              ),
            ),
            const SizedBox(width: DelSizes.spaceBtwItems / 2),
            Text("Paypal", style: Theme.of(context).textTheme.bodyLarge),
          ],
        )
      ],
    );
  }
}
