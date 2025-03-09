import 'package:flutter/material.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/features/auth/presentation/widgets/forget_password_form_section.dart';
import 'package:delcommerce/features/auth/presentation/widgets/forget_password_header_section.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Padding(
        padding: EdgeInsets.all(DelSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ForgetPasswordHeaderSection(),
            SizedBox(
              height: DelSizes.spaceBtwSections,
            ),
            ForgetPasswordFormSection(),
          ],
        ),
      ),
    );
  }
}
