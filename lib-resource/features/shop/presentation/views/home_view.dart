import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:delcommerce/core/common/view_models/grid_layout_view_model.dart';
import 'package:delcommerce/core/common/view_models/section_heading_view_model.dart';
import 'package:delcommerce/core/common/widgets/section_heading.dart';
import 'package:delcommerce/core/common/widgets/vertical_product_card.dart';
import 'package:delcommerce/core/cubits/banner_carousel_slider_cubit_cubit/banner_carousel_slider_cubit.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';
import 'package:delcommerce/core/utils/service_locator/service_locator.dart';
import 'package:delcommerce/features/auth/presentation/widgets/grid_layout.dart';
import 'package:delcommerce/features/shop/presentation/controller/shop_cubit.dart';
import 'package:delcommerce/features/shop/presentation/views/all_products_view.dart';
import 'package:delcommerce/features/shop/presentation/widgets/home_header_section.dart';
import 'package:delcommerce/features/shop/presentation/widgets/promo_banner_carousel_slider.dart';

class HomeViewShimmer extends StatelessWidget {
  const HomeViewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = DelHelperFunctions.isDarkMode(context);
    return Shimmer.fromColors(
      baseColor: dark ? Colors.grey[850]! : Colors.grey[300]!,
      highlightColor: dark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Column(
        children: [
          // Header Section Shimmer
          Container(
            height: 60,
            padding: const EdgeInsets.all(DelSizes.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(DelSizes.cardRadiusLg),
            ),
          ),
          const SizedBox(height: DelSizes.spaceBtwSections),

          // Banner Carousel Shimmer
          Container(
            height: 180,
            margin:
                const EdgeInsets.symmetric(horizontal: DelSizes.defaultSpace),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(DelSizes.cardRadiusLg),
            ),
          ),
          const SizedBox(height: DelSizes.spaceBtwSections),

          // Section Heading Shimmer
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: DelSizes.defaultSpace),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 120,
                  height: 20,
                  color: Colors.white,
                ),
                Container(
                  width: 80,
                  height: 20,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(height: DelSizes.spaceBtwItems),

          // Grid Layout Shimmer
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding:
                const EdgeInsets.symmetric(horizontal: DelSizes.defaultSpace),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: DelSizes.gridViewSpacing,
              crossAxisSpacing: DelSizes.gridViewSpacing,
              mainAxisExtent: 288,
            ),
            itemCount: 4,
            itemBuilder: (_, __) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(DelSizes.productImageRadius),
              ),
              child: Column(
                children: [
                  // Product Image Shimmer
                  Expanded(
                    flex: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(DelSizes.productImageRadius),
                      ),
                    ),
                  ),
                  // Product Details Shimmer
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(DelSizes.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(height: DelSizes.spaceBtwItems / 2),
                          Container(
                            width: 100,
                            height: 16,
                            color: Colors.white,
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 60,
                                height: 20,
                                color: Colors.white,
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HomeHeaderSection(),
              const SizedBox(height: DelSizes.spaceBtwSections),
              BlocProvider(
                create: (context) => BannerCarouselSliderCubit(),
                child: const PromoBannerCarouselSlider(),
              ),
              const SizedBox(height: DelSizes.spaceBtwSections),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SectionHeading(
                  sectionHeadingModel: SectionHeadingModel(
                    title: "Top Rated Products",
                    showActionButton: true,
                    textColor: TColors.primary,
                    actionButtonOnPressed: () {
                      DelHelperFunctions.navigateToScreen(
                        context,
                        BlocProvider(
                          create: (context) => getIt<ShopCubit>()
                            ..getSortedProducts(
                                sortBy: 'rating', sortType: "desc"),
                          child: const AllProductsView(),
                        ),
                      );
                    },
                    actionButtonTitle: "View All",
                  ),
                ),
              ),
              const SizedBox(height: DelSizes.spaceBtwItems),
              BlocBuilder<ShopCubit, ShopState>(
                builder: (context, state) {
                  if (state is ShopError) {
                    return Text(state.error.message);
                  }
                  if (state is ShopSortedProductsLoaded) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridLayout(
                        gridLayoutModel: GridLayoutModel(
                          itemCount: state.productsList.length,
                          itemBuilder: (context, index) {
                            return VerticalProductCard(
                              product: state.productsList[index],
                            );
                          },
                          mainAxisExtent: 288,
                        ),
                      ),
                    );
                  }
                  return const HomeViewShimmer();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
