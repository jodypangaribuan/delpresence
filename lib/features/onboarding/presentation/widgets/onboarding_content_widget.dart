import 'package:flutter/material.dart';
import '../../../../core/utils/size_config.dart';
import '../../domain/models/onboarding_content.dart';

class OnboardingContentWidget extends StatelessWidget {
  final OnboardingContent content;

  const OnboardingContentWidget({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(content.image),
          ),
          SizedBox(
            height: (height >= 840) ? 60 : 30,
          ),
          Text(
            content.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Mulish",
              fontWeight: FontWeight.w600,
              fontSize: (width <= 550) ? 30 : 35,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            content.desc,
            style: TextStyle(
              fontFamily: "Mulish",
              fontWeight: FontWeight.w300,
              fontSize: (width <= 550) ? 17 : 25,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
