import 'package:flutter/material.dart';
import 'package:delcommerce/core/common/view_models/app_bar_view_model.dart';
import 'package:delcommerce/core/common/widgets/app_bar.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/features/shop/presentation/widgets/orders_list.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarModel: AppBarModel(
            title: Text(
          "My Orders",
          style: Theme.of(context).textTheme.headlineSmall,
        )),
      ),
      body: const Padding(
        padding: EdgeInsets.all(DelSizes.defaultSpace),
        child: OrdersList(),
      ),
    );
  }
}
