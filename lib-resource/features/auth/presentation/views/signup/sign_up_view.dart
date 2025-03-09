import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/constants/text_strings.dart';
import 'package:delcommerce/features/auth/presentation/logic/register/register_cubit.dart';
import 'package:delcommerce/features/auth/presentation/widgets/divider_widget.dart';
import 'package:delcommerce/features/auth/presentation/widgets/sign_in_methods_section.dart';
import 'package:delcommerce/features/auth/presentation/widgets/sign_up_form_section.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(w
      create: (context) => RegisterCubit(),
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(DelSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DelTexts.signUpTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: DelSizes.spaceBtwSections),
                  const SignUpFormSection(),
                  const SizedBox(height: DelSizes.spaceBtwSections),
                  const DividerWidget(text: DelTexts.orSignUpWith),
                  const SizedBox(height: DelSizes.spaceBtwSections),
                  const SignInMethodsSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
