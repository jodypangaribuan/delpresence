import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import 'reset_password_screen.dart';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({Key? key}) : super(key: key);

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged(String value, int index) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar color to match app theme
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.all(AppSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'OTP Verification',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                ),
                const SizedBox(height: AppSizes.sm),

                // Subtitle
                Text(
                  'Enter the 4-digit code sent to your email address',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.darkGrey,
                      ),
                ),
                const SizedBox(height: AppSizes.spaceBtwSections),

                // OTP Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    4,
                    (index) => SizedBox(
                      width: 64,
                      child: TextFormField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        onChanged: (value) => _onCodeChanged(value, index),
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                AppSizes.inputFieldRadius),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                AppSizes.inputFieldRadius),
                            borderSide: BorderSide(color: AppColors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                AppSizes.inputFieldRadius),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          filled: true,
                          fillColor: AppColors.lightGrey.withOpacity(0.1),
                          counterText: '',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.spaceBtwSections),

                // Resend Code Timer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Code expires in: ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.darkGrey,
                          ),
                    ),
                    Text(
                      '01:30',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),

                // Resend Code Button
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Resend code logic here
                    },
                    child: Text(
                      'Resend Code',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.spaceBtwSections),

                // Verify Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to reset password screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResetPasswordScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.buttonRadius),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.buttonHeight),
                    ),
                    child: Text(
                      'VERIFY'.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
