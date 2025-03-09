import 'package:flutter/material.dart';
import 'package:delcommerce/core/common/view_models/horizontal_small_list_view_item_view_model.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';
import 'package:delcommerce/features/shop/presentation/views/sub_category_view.dart';

class HorizontalSmallListViewItem extends StatelessWidget {
  const HorizontalSmallListViewItem({
    super.key,
    required this.item,
  });

  final HorizontalSmallListViewItemModel item;

  @override
  Widget build(BuildContext context) {
    final dark = DelHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: () =>
          DelHelperFunctions.navigateToScreen(context, const SubCategoryView()),
      child: Padding(
        padding: const EdgeInsets.only(right: DelSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 56,
              width: 56,
              padding: const EdgeInsets.all(DelSizes.sm),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(100),
                ),
                color: item.backgroundColor ??
                    (dark ? TColors.white : TColors.black),
              ),
              child: Center(
                child: Image(
                    image: AssetImage(item.image),
                    fit: BoxFit.cover,
                    color: dark ? TColors.black : TColors.white),
              ),
            ),
            const SizedBox(height: DelSizes.spaceBtwItems / 2),
            Text(item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium!.apply(
                      color: item.textColor,
                    )),
          ],
        ),
      ),
    );
  }
}
