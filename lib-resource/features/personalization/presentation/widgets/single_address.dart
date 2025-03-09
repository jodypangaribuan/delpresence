import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:delcommerce/core/common/view_models/circular_container_view_model.dart';
import 'package:delcommerce/core/common/widgets/circular_container.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';
import 'package:delcommerce/features/personalization/presentation/view_models/single_address_model.dart';

class SingleAddress extends StatelessWidget {
  const SingleAddress({super.key, required this.singleAddressModel});
  final SingleAddressModel singleAddressModel;
  @override
  Widget build(BuildContext context) {
    final dark = DelHelperFunctions.isDarkMode(context);
    return CircularContainer(
      circularContainerModel: CircularContainerModel(
          padding: const EdgeInsets.all(DelSizes.md),
          width: double.infinity,
          showBorder: true,
          color: singleAddressModel.isSelected
              ? TColors.primary.withOpacity(.5)
              : Colors.transparent,
          borderColor: singleAddressModel.isSelected
              ? Colors.transparent
              : dark
                  ? TColors.darkerGrey
                  : TColors.grey,
          margin: const EdgeInsets.only(bottom: DelSizes.spaceBtwItems),
          child: Stack(
            children: [
              Positioned(
                right: 5,
                top: 0,
                child: Icon(
                  singleAddressModel.isSelected ? Iconsax.tick_circle5 : null,
                  color: singleAddressModel.isSelected
                      ? dark
                          ? TColors.light
                          : TColors.dark //.withOpacity(.6)
                      : null,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    singleAddressModel.name,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: DelSizes.sm / 2,
                  ),
                  Text(
                    singleAddressModel.phoneNumber,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: DelSizes.sm / 2,
                  ),
                  Text(
                    singleAddressModel.address,
                    softWrap: true,
                  ),
                ],
              )
            ],
          )),
    );
  }
}
