import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:delcommerce/core/common/view_models/app_bar_view_model.dart';
import 'package:delcommerce/core/common/view_models/circular_icon_view_model.dart';
import 'package:delcommerce/core/common/view_models/grid_layout_view_model.dart';
import 'package:delcommerce/core/common/widgets/app_bar.dart';
import 'package:delcommerce/core/common/widgets/circular_icon.dart';
import 'package:delcommerce/core/common/widgets/vertical_product_card.dart';
import 'package:delcommerce/core/cubits/navigation_menu_cubit/navigation_menu_cubit.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/constants/text_strings.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';
import 'package:delcommerce/features/auth/presentation/widgets/grid_layout.dart';
import 'package:delcommerce/features/shop/domain/entities/product_entity.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = DelHelperFunctions.isDarkMode(context);
    return Scaffold(
        appBar: CustomAppBar(
          appBarModel: AppBarModel(
            actions: [
              CircularIcon(
                circularIconModel: CircularIconModel(
                    color: dark ? TColors.white : TColors.dark,
                    icon: Iconsax.add,
                    onPressed: () =>
                        context.read<NavigationMenuCubit>().changeIndex(0)),
              )
            ],
            title: Text(DelTexts.wishlistView,
                style: Theme.of(context).textTheme.headlineMedium),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(DelSizes.defaultSpace),
              child: Column(
                children: [
                  GridLayout(
                    gridLayoutModel: GridLayoutModel(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return VerticalProductCard(
                          product: ProductEntity(
                              id: index,
                              title: "Product $index",
                              price: 100,
                              images: const ["https://picsum.photos/200"],
                              category: "Category $index",
                              description: "Description $index",
                              rating: 4.5,
                              availabilityStatus: "",
                              brand: "  Brand $index",
                              createdAt: DateTime.now(),
                              discountPercentage: 0,
                              returnPolicy: "Return Policy $index",
                              reviews: const [],
                              shippingInformation: "",
                              stock: 5,
                              tags: const [],
                              thumbnail: "",
                              warrantyInformation: ""),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
