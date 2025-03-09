import 'package:flutter/material.dart';
import 'package:delcommerce/core/common/view_models/category_tab_view_model.dart';
import 'package:delcommerce/core/common/view_models/grid_layout_view_model.dart';
import 'package:delcommerce/core/common/view_models/section_heading_view_model.dart';
import 'package:delcommerce/core/common/widgets/brand_showcase.dart';
import 'package:delcommerce/core/common/widgets/section_heading.dart';
import 'package:delcommerce/core/common/widgets/vertical_product_card.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/features/auth/presentation/widgets/grid_layout.dart';
import 'package:delcommerce/features/shop/domain/entities/product_entity.dart';

class CategoryTab extends StatelessWidget {
  const CategoryTab({
    super.key,
    required this.categoryTabModel,
  });

  final CategoryTabModel categoryTabModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(DelSizes.defaultSpace),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Check if brandShowcaseModel exists before using it
            BrandShowcase(
              categoryTabModel.brandShowcaseModel,
            ),
            const SizedBox(
              height: DelSizes.spaceBtwItems,
            ),
            SectionHeading(
              sectionHeadingModel: SectionHeadingModel(
                title: "You Might Like",
                showActionButton: true,
                actionButtonOnPressed: () {},
              ),
            ),
            const SizedBox(
              height: DelSizes.spaceBtwItems,
            ),
            GridLayout(
              gridLayoutModel: GridLayoutModel(
                // Ensure products list is not null and handle bounds
                itemCount: (categoryTabModel.products.length) > 50
                    ? categoryTabModel.products.length - 50
                    : categoryTabModel.products.length,
                itemBuilder: (context, index) {
                  // Ensure index is within bounds
                  if (index >= 0 && index < categoryTabModel.products.length) {
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
                        brand: "Brand $index",
                        createdAt: DateTime.now(),
                        discountPercentage: 0,
                        returnPolicy: "Return Policy $index",
                        reviews: const [],
                        shippingInformation: "",
                        stock: 5,
                        tags: const [],
                        thumbnail: "",
                        warrantyInformation: "",
                      ),
                    );
                  }
                  // Return an empty container if index is out of bounds
                  return Container();
                },
                mainAxisExtent: 280,
              ),
            ),
            const SizedBox(
              height: DelSizes.spaceBtwSections,
            ),
          ],
        ),
      ),
    );
  }
}
