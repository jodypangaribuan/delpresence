import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:delcommerce/core/utils/constants/image_strings.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/constants/text_strings.dart';
import 'package:delcommerce/core/utils/device/device_utility.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';
import 'package:delcommerce/features/auth/presentation/views/login/login_view.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              DelHelperFunctions.navigateReplacementToScreen(
                  context, const LoginView());
            },
            icon: const Icon(CupertinoIcons.clear),
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: DelSizes.paddingWithAppBarHeight,
            child: Column(
              children: [
                Image(
                    width: TDeviceUtils.getScreenWidth(context) * .6,
                    image:
                        const AssetImage(DelImages.deliveredEmailIllustration)),
                const SizedBox(
                  height: DelSizes.spaceBtwSections,
                ),
                Text(
                  DelTexts.changeYourPasswordTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: DelSizes.spaceBtwItems,
                ),
                Text(
                  DelTexts.changeYourPasswordSubTitle,
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: DelSizes.spaceBtwSections,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {}, child: const Text(DelTexts.done)),
                ),
                const SizedBox(
                  height: DelSizes.spaceBtwItems,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () {},
                      child: const Text(DelTexts.resendEmail)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
