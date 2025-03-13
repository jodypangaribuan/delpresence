import 'package:delpresence/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_strings.dart';
import '../bloc/auth_bloc.dart';
import '../screens/register_screen.dart';
import '../screens/forgot_password_screen.dart';

class LoginFormSection extends StatefulWidget {
  const LoginFormSection({Key? key}) : super(key: key);

  @override
  State<LoginFormSection> createState() => _LoginFormSectionState();
}

class _LoginFormSectionState extends State<LoginFormSection> {
  final _formKey = GlobalKey<FormState>();
  final _nimNipController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nimNipController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            LoginEvent(
              nimNip: _nimNipController.text,
              password: _passwordController.text,
            ),
          );
    }
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
    );

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);

          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'Login successful'),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate to home screen
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
              (route) => false,
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // NIM/NIP Field
            TextFormField(
              controller: _nimNipController,
              keyboardType: TextInputType.text,
              decoration: inputDecoration.copyWith(
                labelText: AppTexts.email,
                hintText: AppTexts.nimNipHint,
                prefixIcon: Icon(Iconsax.card, color: AppColors.darkGrey),
                labelStyle: TextStyle(color: AppColors.darkGrey),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppTexts.requiredField;
                }
                // Custom validation for NIM/NIP format can be added here
                return null;
              },
            ),
            const SizedBox(height: AppSizes.spaceBtwInputFields),

            // Password Field
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: inputDecoration.copyWith(
                labelText: AppTexts.password,
                hintText: AppTexts.passwordHint,
                prefixIcon:
                    Icon(Iconsax.password_check, color: AppColors.darkGrey),
                labelStyle: TextStyle(color: AppColors.darkGrey),
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
            const SizedBox(height: AppSizes.spaceBtwInputFields / 2),

            // Remember Me & Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Remember Me
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? true;
                        });
                      },
                      activeColor: AppColors.primary,
                    ),
                    Text(
                      AppTexts.rememberMe,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.darkGrey,
                          ),
                    ),
                  ],
                ),

                // Forgot Password
                TextButton(
                  onPressed: () {
                    // Navigate to forgot password screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                  child: Text(
                    AppTexts.forgotPassword,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceBtwSections),

            // Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                  ),
                  elevation: 1,
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        AppTexts.loginButton,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: AppSizes.spaceBtwItems),

            // Create Account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppTexts.dontHaveAccount,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.darkGrey,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                  child: Text(
                    AppTexts.createAccount,
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
      ),
    );
  }
}
