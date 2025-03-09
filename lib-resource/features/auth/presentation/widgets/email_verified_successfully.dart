import 'package:flutter/material.dart';
import 'package:delcommerce/core/common/view_models/success_view_model.dart';
import 'package:delcommerce/core/utils/constants/image_strings.dart';
import 'package:delcommerce/core/utils/constants/text_strings.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';
import 'package:delcommerce/core/common/widgets/success_view.dart';
import 'package:delcommerce/features/auth/presentation/views/login/login_view.dart';

class EmailVerifiedSuccessfully extends StatelessWidget {
  const EmailVerifiedSuccessfully({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SuccessView(
      successModel: SuccessModel(
        image: DelImages.staticSuccessIllustration,
        title: DelTexts.yourAccountCreatedTitle,
        subTitle: DelTexts.yourAccountCreatedSubTitle,
        buttonText: DelTexts.tContinue,
        onPressed: () {
          DelHelperFunctions.navigateReplacementToScreen(
              context, const LoginView());
        },
      ),
    );
  }
}
