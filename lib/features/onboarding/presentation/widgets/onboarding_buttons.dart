import 'package:flutter/material.dart';
import '../../../../core/utils/size_config.dart';

class OnboardingButtons extends StatelessWidget {
  final int currentPage;
  final int pageCount;
  final PageController controller;

  const OnboardingButtons({
    Key? key,
    required this.currentPage,
    required this.pageCount,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenW!;

    return Padding(
      padding: const EdgeInsets.all(30),
      child: currentPage + 1 == pageCount
          ? _buildStartButton(width)
          : _buildNavigationButtons(width),
    );
  }

  Widget _buildStartButton(double width) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        padding: (width <= 550)
            ? const EdgeInsets.symmetric(horizontal: 100, vertical: 20)
            : EdgeInsets.symmetric(horizontal: width * 0.2, vertical: 25),
        textStyle: TextStyle(fontSize: (width <= 550) ? 13 : 17),
      ),
      child: const Text("START"),
    );
  }

  Widget _buildNavigationButtons(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => controller.jumpToPage(pageCount - 1),
          style: TextButton.styleFrom(
            elevation: 0,
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: (width <= 550) ? 13 : 17,
            ),
          ),
          child: const Text(
            "SKIP",
            style: TextStyle(color: Colors.black),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            controller.nextPage(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 0,
            padding: (width <= 550)
                ? const EdgeInsets.symmetric(horizontal: 30, vertical: 20)
                : const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
            textStyle: TextStyle(fontSize: (width <= 550) ? 13 : 17),
          ),
          child: const Text(
            "NEXT",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
