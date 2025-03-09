import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_strings.dart';

class TermsAndPrivacyAgreement extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const TermsAndPrivacyAgreement({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black,
                  ),
              children: [
                TextSpan(text: '${AppTexts.iAgreeTo} '),
                TextSpan(
                  text: AppTexts.privacyPolicy,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: AppTexts.and),
                TextSpan(
                  text: AppTexts.termsOfUse,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
