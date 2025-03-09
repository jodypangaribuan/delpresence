import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:delcommerce/core/common/view_models/app_bar_view_model.dart';
import 'package:delcommerce/core/common/view_models/circular_icon_view_model.dart';
import 'package:delcommerce/core/common/widgets/app_bar.dart';
import 'package:delcommerce/core/common/widgets/circular_icon.dart';
import 'package:delcommerce/core/common/widgets/curved_widget.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';
import 'package:delcommerce/features/shop/presentation/widgets/other_same_products_list.dart';
import 'package:delcommerce/features/shop/presentation/widgets/selected_product_image.dart';

class ProducDelImageslider extends StatelessWidget {
  const ProducDelImageslider({
    super.key,
  });

//ProducDelImageslider >> product_image_slider.dart
  @override
  Widget build(BuildContext context) {
    final dark = DelHelperFunctions.isDarkMode(context);

    return CurvedWidget(
      child: Container(
        decoration: BoxDecoration(
          color: dark ? TColors.darkGrey : TColors.light,
        ),
        child: Stack(
          children: [
            const SelectedProductImage(),
            const OtherSameProductsList(),
            CustomAppBar(
                appBarModel: AppBarModel(hasArrowBack: true, actions: [
              CircularIcon(
                circularIconModel:
                    CircularIconModel(icon: Iconsax.heart5, color: Colors.red),
              ),
            ]))
          ],
        ),
      ),
    );
  }
}
