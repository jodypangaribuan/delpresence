import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_strings.dart';
import '../screens/login_screen.dart';
import 'terms_and_privacy_agreement.dart';

class SignUpFormSection extends StatefulWidget {
  const SignUpFormSection({Key? key}) : super(key: key);

  @override
  State<SignUpFormSection> createState() => _SignUpFormSectionState();
}

class _SignUpFormSectionState extends State<SignUpFormSection> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(AppSizes.md),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: BorderSide(color: AppColors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: BorderSide(color: AppColors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: BorderSide(color: AppColors.error),
      ),
      labelStyle: TextStyle(color: AppColors.darkGrey),
    );

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // First Name & Last Name
          Row(
            children: [
              // First Name
              Expanded(
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: inputDecoration.copyWith(
                    labelText: AppTexts.firstName,
                    hintText: 'John',
                    prefixIcon: Icon(Iconsax.user, color: AppColors.darkGrey),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppTexts.requiredField;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: AppSizes.spaceBtwInputFields),
              // Last Name
              Expanded(
                child: TextFormField(
                  controller: _lastNameController,
                  decoration: inputDecoration.copyWith(
                    labelText: AppTexts.lastName,
                    hintText: 'Doe',
                    prefixIcon: Icon(Iconsax.user, color: AppColors.darkGrey),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppTexts.requiredField;
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceBtwInputFields),

          // Email
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: inputDecoration.copyWith(
              labelText: AppTexts.email,
              hintText: 'example@email.com',
              prefixIcon: Icon(Iconsax.sms, color: AppColors.darkGrey),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppTexts.requiredField;
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return AppTexts.invalidEmail;
              }
              return null;
            },
          ),
          const SizedBox(height: AppSizes.spaceBtwInputFields),

          // Phone Number
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: inputDecoration.copyWith(
              labelText: AppTexts.phoneNumber,
              hintText: '+1234567890',
              prefixIcon: Icon(Iconsax.call, color: AppColors.darkGrey),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppTexts.requiredField;
              }
              if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                return AppTexts.invalidPhoneNumber;
              }
              return null;
            },
          ),
          const SizedBox(height: AppSizes.spaceBtwInputFields),

          // Password
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: inputDecoration.copyWith(
              labelText: AppTexts.password,
              hintText: '••••••••',
              prefixIcon:
                  Icon(Iconsax.password_check, color: AppColors.darkGrey),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword ? Iconsax.eye_slash : Iconsax.eye,
                  color: AppColors.darkGrey,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppTexts.requiredField;
              }
              if (value.length < 6) {
                return AppTexts.invalidPassword;
              }
              return null;
            },
          ),
          const SizedBox(height: AppSizes.spaceBtwInputFields),

          // Confirm Password
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: inputDecoration.copyWith(
              labelText: AppTexts.confirmPassword,
              hintText: '••••••••',
              prefixIcon:
                  Icon(Iconsax.password_check, color: AppColors.darkGrey),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
                icon: Icon(
                  _obscureConfirmPassword ? Iconsax.eye_slash : Iconsax.eye,
                  color: AppColors.darkGrey,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppTexts.requiredField;
              }
              if (value != _passwordController.text) {
                return AppTexts.passwordMismatch;
              }
              return null;
            },
          ),
          const SizedBox(height: AppSizes.spaceBtwInputFields),

          // Terms and Conditions
          TermsAndPrivacyAgreement(
            value: _agreeToTerms,
            onChanged: (value) {
              setState(() {
                _agreeToTerms = value ?? false;
              });
            },
          ),
          const SizedBox(height: AppSizes.spaceBtwSections),

          // Sign Up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _agreeToTerms
                  ? () {
                      if (_formKey.currentState!.validate()) {
                        // Perform registration
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                ),
                elevation: 1,
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: Text(
                AppTexts.signUp.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spaceBtwItems),

          // Already have an account
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppTexts.alreadyHaveAccount,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.darkGrey,
                    ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
                child: Text(
                  AppTexts.signIn,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
