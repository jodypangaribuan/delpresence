import 'package:flutter/material.dart';
import 'package:delcommerce/core/utils/constants/image_strings.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/common/widgets/banner_carousel_slider.dart';

class PromoBannerCarouselSlider extends StatelessWidget {
  const PromoBannerCarouselSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DelSizes.defaultSpace),
      child: BannerCarouselSlider(
        images: DelImages.promoBannerImages,
      ),
    );
  }
}
