import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class OnboardingDot extends StatelessWidget {
  final bool isActive;

  const OnboardingDot({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        color: AppColors.primaryBlack,
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: isActive ? 20 : 10,
    );
  }
}
