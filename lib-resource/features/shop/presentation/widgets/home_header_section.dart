import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:delcommerce/core/common/view_models/search_container_view_model.dart';
import 'package:delcommerce/core/common/view_models/section_heading_view_model.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/constants/text_strings.dart';
import 'package:delcommerce/core/common/widgets/primary_header_container.dart';
import 'package:delcommerce/core/common/widgets/search_container.dart';
import 'package:delcommerce/core/common/widgets/section_heading.dart';
import 'package:delcommerce/features/shop/presentation/widgets/home_app_bar.dart';
import 'package:delcommerce/features/shop/presentation/widgets/home_categories.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final SectionHeadingModel sectionHeadingModel = SectionHeadingModel(
      showActionButton: false,
      title: DelTexts.popularCategories,
      textColor: TColors.white,
    );
    final SearchContainerModel searchContainerModel = SearchContainerModel(
      icon: Iconsax.search_normal,
      title: DelTexts.searchContainer,
      showBackground: true,
      showBorder: true,
    );

    return PrimaryHeaderContainer(
      child: Column(
        children: [
          const HomeAppBar(),
          const SizedBox(height: DelSizes.spaceBtwSections),
          SearchContainer(searchContainerModel: searchContainerModel),
          const SizedBox(
            height: DelSizes.spaceBtwSections,
          ),
          Padding(
              padding: const EdgeInsets.only(left: DelSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeading(
                    sectionHeadingModel: sectionHeadingModel,
                  ),
                  const SizedBox(height: DelSizes.spaceBtwSections),
                  const HomeCategories(),
                  const SizedBox(height: DelSizes.spaceBtwSections),
                ],
              ))
        ],
      ),
    );
  }
}
