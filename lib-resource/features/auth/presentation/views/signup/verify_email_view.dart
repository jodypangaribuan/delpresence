import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:delcommerce/core/utils/constants/image_strings.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/constants/text_strings.dart';
import 'package:delcommerce/core/utils/device/device_utility.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';
import 'package:delcommerce/features/auth/presentation/views/login/login_view.dart';
import 'package:delcommerce/features/auth/presentation/widgets/email_verified_successfully.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              DelHelperFunctions.navigateReplacementToScreen(
                  context, const LoginView());
            },
            icon: const Icon(CupertinoIcons.clear),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(DelSizes.defaultSpace),
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
                  DelTexts.confirmEmailTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: DelSizes.spaceBtwItems,
                ),
                Text(
                  DelTexts.confirmEmail,
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: DelSizes.spaceBtwItems,
                ),
                Text(
                  DelTexts.confirmEmailSubTitle,
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: DelSizes.spaceBtwSections,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        DelHelperFunctions.navigateReplacementToScreen(
                            context, const EmailVerifiedSuccessfully());
                      },
                      child: const Text(DelTexts.tContinue)),
                ),
                const SizedBox(
                  height: DelSizes.spaceBtwItems,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () {},
                      child: const Text(DelTexts.resendEmail)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
