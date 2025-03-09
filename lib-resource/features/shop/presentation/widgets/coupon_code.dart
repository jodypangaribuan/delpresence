import 'package:flutter/material.dart';
import 'package:delcommerce/core/common/view_models/circular_container_view_model.dart';
import 'package:delcommerce/core/common/widgets/circular_container.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';

class CouponCode extends StatelessWidget {
  const CouponCode({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final dark = DelHelperFunctions.isDarkMode(context);
    return CircularContainer(
      circularContainerModel: CircularContainerModel(
          padding: const EdgeInsets.fromLTRB(
              DelSizes.md, DelSizes.sm, DelSizes.sm, DelSizes.sm),
          showBorder: true,
          color: dark ? TColors.dark : TColors.white,
          child: Row(
            children: [
              Flexible(
                child: TextFormField(
                  decoration: const InputDecoration(
                      hintText: "Have a promo code? Enter here",
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      border: InputBorder.none),
                ),
              ),
              SizedBox(
                width: 80,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(DelSizes.md),
                      foregroundColor: dark
                          ? TColors.white.withOpacity(.5)
                          : TColors.dark.withOpacity(.5),
                      backgroundColor: Colors.grey.withOpacity(.2),
                      side: BorderSide(color: Colors.grey.withOpacity(.1)),
                    ),
                    onPressed: () {},
                    child: const Text("Apply")),
              )
            ],
          )),
    );
  }
}
