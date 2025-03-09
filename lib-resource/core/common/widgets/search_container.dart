import 'package:flutter/material.dart';
import 'package:delcommerce/core/common/view_models/search_container_view_model.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/device/device_utility.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';

class SearchContainer extends StatelessWidget {
  const SearchContainer({
    super.key,
    required this.searchContainerModel,
  });
  final SearchContainerModel searchContainerModel;
  @override
  Widget build(BuildContext context) {
    final dark = DelHelperFunctions.isDarkMode(context);
    return Padding(
      padding: searchContainerModel.padding,
      child: GestureDetector(
        onTap: searchContainerModel.onPressed,
        child: Container(
          width: TDeviceUtils.getScreenWidth(context),
          padding: const EdgeInsets.all(DelSizes.md),
          decoration: BoxDecoration(
            color: searchContainerModel.showBackground
                ? dark
                    ? TColors.dark
                    : TColors.light
                : Colors.transparent,
            borderRadius: BorderRadius.circular(DelSizes.cardRadiusLg),
            border: searchContainerModel.showBorder
                ? Border.all(
                    color: TColors.grey,
                  )
                : null,
          ),
          child: Row(
            children: [
              Icon(searchContainerModel.icon, color: TColors.darkGrey),
              const SizedBox(width: DelSizes.spaceBtwItems),
              Text(
                searchContainerModel.title,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//search container model
