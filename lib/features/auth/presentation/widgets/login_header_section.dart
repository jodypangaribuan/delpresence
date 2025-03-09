import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_strings.dart';

class LoginHeaderSection extends StatelessWidget {
  const LoginHeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo dengan ukuran lebih besar dan posisi di tengah
        Container(
          margin: const EdgeInsets.only(bottom: AppSizes.spaceBtwItems * 1.5),
          width: double.infinity,
          child: Center(
            child: Image.asset(
              'assets/images/logo.png',
              height: 150,
            ),
          ),
        ),

        // Title dengan style yang diperbaiki
        Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.sm),
          child: Text(
            AppTexts.loginTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                  fontSize: 30,
                ),
          ),
        ),

        // Subtitle dengan style yang diperbaiki
        Text(
          AppTexts.loginSubtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.darkGrey,
                fontSize: 16,
              ),
        ),
        const SizedBox(height: AppSizes.spaceBtwSections),
      ],
    );
  }
}
