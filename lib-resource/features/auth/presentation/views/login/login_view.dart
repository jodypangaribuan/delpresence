import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/constants/text_strings.dart';
import 'package:delcommerce/core/utils/service_locator/service_locator.dart';
import 'package:delcommerce/features/auth/presentation/logic/login/login_cubit.dart';
import 'package:delcommerce/features/auth/presentation/widgets/divider_widget.dart';
import 'package:delcommerce/features/auth/presentation/widgets/login_form_section.dart';
import 'package:delcommerce/features/auth/presentation/widgets/login_header_section.dart';
import 'package:delcommerce/features/auth/presentation/widgets/sign_in_methods_section.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: const Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: DelSizes.paddingWithAppBarHeight,
              child: Column(
                children: [
                  LoginHeaderSection(),
                  LoginFormSection(),
                  DividerWidget(
                    text: DelTexts.orSignInWith,
                  ),
                  SizedBox(
                    height: DelSizes.spaceBtwSections,
                  ),
                  SignInMethodsSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
