import 'package:flutter/material.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';
import 'package:delcommerce/features/auth/presentation/view_models/on_boarding_model.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.onBoardingModel,
  });
  final OnBoardingModel onBoardingModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(DelSizes.defaultSpace),
      child: Column(
        children: [
          Image(
            width: DelHelperFunctions.screenWidth(context) * .8,
            height: DelHelperFunctions.screenHeight(context) * .6,
            image: AssetImage(onBoardingModel.image),
          ),
          Text(
            onBoardingModel.title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: DelSizes.spaceBtwItems,
          ),
          Text(
            onBoardingModel.subTitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
