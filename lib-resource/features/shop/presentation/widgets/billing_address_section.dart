import 'package:flutter/material.dart';
import 'package:delcommerce/core/common/view_models/section_heading_view_model.dart';
import 'package:delcommerce/core/common/widgets/section_heading.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';

class BillingAddressSection extends StatelessWidget {
  const BillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeading(
          sectionHeadingModel: SectionHeadingModel(
            title: "Shipping Address",
            actionButtonOnPressed: () {},
            showActionButton: true,
            actionButtonTitle: "Change",
          ),
        ),
        Text("Code With Me ", style: Theme.of(context).textTheme.bodyLarge),
        Row(
          children: [
            const Icon(
              Icons.phone,
              size: 16,
              color: Colors.grey,
            ),
            const SizedBox(
              width: DelSizes.spaceBtwItems,
            ),
            Text(
              "+20-123456789",
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
        const SizedBox(
          height: DelSizes.spaceBtwItems / 2,
        ),
        Row(
          children: [
            const Icon(
              Icons.location_history,
              size: 16,
              color: Colors.grey,
            ),
            const SizedBox(
              width: DelSizes.spaceBtwItems,
            ),
            Text(
              "123 Street, Egypt",
              softWrap: true,
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
        const SizedBox(
          height: DelSizes.spaceBtwItems / 2,
        ),
      ],
    );
  }
}
