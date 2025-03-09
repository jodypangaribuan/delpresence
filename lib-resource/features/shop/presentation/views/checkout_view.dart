import 'package:flutter/material.dart';
import 'package:delcommerce/core/common/view_models/app_bar_view_model.dart';
import 'package:delcommerce/core/common/view_models/circular_container_view_model.dart';
import 'package:delcommerce/core/common/view_models/success_view_model.dart';
import 'package:delcommerce/core/common/widgets/app_bar.dart';
import 'package:delcommerce/core/common/widgets/circular_container.dart';
import 'package:delcommerce/core/common/widgets/navigation_menu.dart';
import 'package:delcommerce/core/common/widgets/success_view.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/constants/image_strings.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';
import 'package:delcommerce/features/shop/presentation/widgets/billing_address_section.dart';
import 'package:delcommerce/features/shop/presentation/widgets/billing_amount_sction.dart';
import 'package:delcommerce/features/shop/presentation/widgets/billing_payment_section.dart';
import 'package:delcommerce/features/shop/presentation/widgets/cart_items_list.dart';
import 'package:delcommerce/features/shop/presentation/widgets/coupon_code.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = DelHelperFunctions.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(DelSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: () {
            DelHelperFunctions.navigateToScreen(
                context,
                SuccessView(
                  successModel: SuccessModel(
                    onPressed: () {
                      DelHelperFunctions.navigateReplacementToScreen(
                          context, const NavigationMenu());
                    },
                    image: DelImages.successfulPaymentIcon,
                    buttonText: "Done",
                    subTitle: "You Item Will Be Shipped Soon!",
                    title: "Payment Successful",
                  ),
                ));
          },
          child: const Text("Checkout \$175"),
        ),
      ),
      appBar: CustomAppBar(
          appBarModel: AppBarModel(
              hasArrowBack: true,
              title: Text(
                "Order Review",
                style: Theme.of(context).textTheme.headlineSmall,
              ))),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(DelSizes.defaultSpace),
            child: Column(
              children: [
                const CartItemsList(
                  showAddRemoveButtons: false,
                ),
                const SizedBox(
                  height: DelSizes.spaceBtwSections,
                ),
                const CouponCode(),
                const SizedBox(
                  height: DelSizes.spaceBtwSections,
                ),
                CircularContainer(
                    circularContainerModel: CircularContainerModel(
                        showBorder: true,
                        padding: const EdgeInsets.all(DelSizes.md),
                        color: dark ? TColors.black : TColors.white,
                        child: const Column(
                          children: [
                            BillingAmountSection(),
                            SizedBox(
                              height: DelSizes.spaceBtwItems,
                            ),
                            Divider(),
                            SizedBox(
                              height: DelSizes.spaceBtwItems,
                            ),
                            BillingPaymentSection(),
                            SizedBox(
                              height: DelSizes.spaceBtwItems,
                            ),
                            Divider(),
                            SizedBox(
                              height: DelSizes.spaceBtwItems,
                            ),
                            BillingAddressSection()
                          ],
                        ))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
