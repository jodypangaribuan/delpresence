import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:delcommerce/core/utils/constants/image_strings.dart';
import 'package:delcommerce/core/utils/constants/text_strings.dart';
import 'package:delcommerce/features/auth/presentation/view_models/on_boarding_model.dart';
import 'package:delcommerce/features/auth/presentation/logic/on_boarding/on_boarding_cubit.dart';
import 'package:delcommerce/features/auth/presentation/widgets/on_boarding_dot_navigation.dart';
import 'package:delcommerce/features/auth/presentation/widgets/on_boarding_next_button.dart';
import 'package:delcommerce/features/auth/presentation/widgets/on_boarding_page.dart';
import 'package:delcommerce/features/auth/presentation/widgets/on_boarding_skip_button.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingCubit, OnBoardingState>(
      builder: (context, state) {
        final onBoardingCubit = context.read<OnBoardingCubit>();
        final pageController = onBoardingCubit.pageController;
        return Scaffold(
          body: Stack(
            children: [
              PageView(
                controller: pageController,
                onPageChanged: (index) {
                  context.read<OnBoardingCubit>().updatePageIndicator(index);
                },
                physics: const BouncingScrollPhysics(),
                children: [
                  OnBoardingPage(
                    onBoardingModel: OnBoardingModel(
                      image: DelImages.onBoardingImage1,
                      title: DelTexts.onBoardingTitle1,
                      subTitle: DelTexts.onBoardingSubTitle1,
                    ),
                  ),
                  OnBoardingPage(
                    onBoardingModel: OnBoardingModel(
                      image: DelImages.onBoardingImage2,
                      title: DelTexts.onBoardingTitle2,
                      subTitle: DelTexts.onBoardingSubTitle2,
                    ),
                  ),
                  OnBoardingPage(
                    onBoardingModel: OnBoardingModel(
                      image: DelImages.onBoardingImage3,
                      title: DelTexts.onBoardingTitle3,
                      subTitle: DelTexts.onBoardingSubTitle3,
                    ),
                  ),
                ],
              ),
              const OnBoardingSkipButton(),
              const OnBoardingDotNavigation(),
              const OnBoardingNextButton()
            ],
          ),
        );
      },
    );
  }
}
