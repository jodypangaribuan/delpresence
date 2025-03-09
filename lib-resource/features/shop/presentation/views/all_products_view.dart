import 'package:flutter/material.dart';
import 'package:delcommerce/core/common/view_models/app_bar_view_model.dart';
import 'package:delcommerce/core/common/widgets/app_bar.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/features/shop/presentation/widgets/sortable_products.dart';

class AllProductsView extends StatelessWidget {
  const AllProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarModel:
            AppBarModel(title: const Text("All Products"), hasArrowBack: true),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(DelSizes.defaultSpace),
          child: SortableProducts(),
        )),
      ),
    );
  }
}
