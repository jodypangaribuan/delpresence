import 'package:flutter/material.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/features/shop/presentation/widgets/order_list_item.dart';

class OrdersList extends StatelessWidget {
  const OrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) => const OrderListItem(),
        separatorBuilder: (context, index) => const SizedBox(
              height: DelSizes.spaceBtwItems,
            ),
        itemCount: 6);
  }
}
