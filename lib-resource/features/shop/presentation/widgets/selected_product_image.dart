import 'package:flutter/material.dart';
import 'package:delcommerce/core/utils/constants/image_strings.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';

class SelectedProductImage extends StatelessWidget {
  const SelectedProductImage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        height: 400,
        child: Padding(
          padding: EdgeInsets.all(DelSizes.productImageRadius * 3),
          child:
              Center(child: Image(image: AssetImage(DelImages.productImage13))),
        ));
  }
}
