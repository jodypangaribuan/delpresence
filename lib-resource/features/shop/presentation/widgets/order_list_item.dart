import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:delcommerce/core/common/view_models/circular_container_view_model.dart';
import 'package:delcommerce/core/common/widgets/circular_container.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';

class OrderListItem extends StatelessWidget {
  const OrderListItem({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = DelHelperFunctions.isDarkMode(context);
    return CircularContainer(
        circularContainerModel: CircularContainerModel(
            showBorder: true,
            color: dark ? TColors.dark : TColors.light,
            padding: const EdgeInsets.all(DelSizes.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Iconsax.ship),
                    const SizedBox(
                      width: DelSizes.spaceBtwItems / 2,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Prossessing",
                            style: Theme.of(context).textTheme.bodyLarge!.apply(
                                color: TColors.primary, fontWeightDelta: 1),
                          ),
                          Text("07 Mar, 2022",
                              style: Theme.of(context).textTheme.headlineSmall),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Iconsax.arrow_right_34,
                      ),
                      iconSize: DelSizes.iconSm,
                    )
                  ],
                ),
                const SizedBox(
                  height: DelSizes.spaceBtwItems,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Iconsax.tag),
                          const SizedBox(
                            width: DelSizes.spaceBtwItems / 2,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Order",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium),
                                Text("#123456",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Iconsax.calendar),
                          const SizedBox(
                            width: DelSizes.spaceBtwItems / 2,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Shipping Date",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium),
                                Text("07 Mar, 2022",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            )));
  }
}
