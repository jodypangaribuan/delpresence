import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:delcommerce/core/common/view_models/app_bar_view_model.dart';
import 'package:delcommerce/core/common/widgets/app_bar.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';
import 'package:delcommerce/features/personalization/presentation/view_models/single_address_model.dart';
import 'package:delcommerce/features/personalization/presentation/views/add_new_addresses_view.dart';
import 'package:delcommerce/features/personalization/presentation/widgets/single_address.dart';

class UserAddressesView extends StatelessWidget {
  const UserAddressesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: TColors.primary,
        onPressed: () {
          DelHelperFunctions.navigateToScreen(
              context, const AddNewAddressesView());
        },
        child: const Icon(Iconsax.add, color: TColors.white),
      ),
      appBar: CustomAppBar(
          appBarModel: AppBarModel(
              hasArrowBack: true,
              title: Text(
                "Addresses",
                style: Theme.of(context).textTheme.headlineSmall,
              ))),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(DelSizes.defaultSpace),
            child: Column(
              children: [
                SingleAddress(
                  singleAddressModel: SingleAddressModel(
                      name: "Mahmoud Hamdy",
                      phoneNumber: "0123456789",
                      address: "8th of October,Cairo,Egypt",
                      isSelected: true),
                ),
                SingleAddress(
                  singleAddressModel: SingleAddressModel(
                      name: "Mahmoud Hamdy",
                      phoneNumber: "0123456789",
                      address: "8th of October,Cairo,Egypt",
                      isSelected: false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
