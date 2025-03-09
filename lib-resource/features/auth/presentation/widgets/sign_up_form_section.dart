import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:delcommerce/core/enums/status.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/core/utils/constants/text_strings.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';
import 'package:delcommerce/core/utils/validators/validation.dart';
import 'package:delcommerce/features/auth/data/models/register_req_body.dart';
import 'package:delcommerce/features/auth/domain/usecases/register_usecase.dart';
import 'package:delcommerce/features/auth/presentation/logic/register/register_cubit.dart';
import 'package:delcommerce/features/auth/presentation/logic/register/register_state.dart';
import 'package:delcommerce/features/auth/presentation/views/login/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'terms_and_privacy_agreement.dart';

class SignUpFormSection extends StatefulWidget {
  const SignUpFormSection({super.key});

  @override
  State<SignUpFormSection> createState() => _SignUpFormSectionState();
}

class _SignUpFormSectionState extends State<SignUpFormSection> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Show loading state
      setState(() {});

      final email = _emailController.text.trim().toLowerCase();
      final password = _passwordController.text.trim();

      // 1. Create Firebase Auth user
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      // 2. Create Firestore document
      if (userCredential.user != null) {
        final userData = {
          'uid': userCredential.user!.uid,
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'email': email,
          'mobile': _phoneController.text.trim(),
          'address': _addressController.text.trim(),
          'createdAt': Timestamp.now(),
          'updatedAt': Timestamp.now(),
        };

        // Store in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userData, SetOptions(merge: true));

        if (!mounted) return;

        // 3. Show success message
        DelHelperFunctions.showSnackBar(
          context: context,
          message: 'Account created successfully!',
          type: SnackBarType.success,
        );

        // 4. Navigate to login
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        DelHelperFunctions.navigateReplacementToScreen(
            context, const LoginView());
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      _handleFirebaseAuthError(e);
    } catch (e) {
      debugPrint('Registration error: $e');
      if (!mounted) return;
      DelHelperFunctions.showSnackBar(
        context: context,
        message: 'Registration failed: $e',
        type: SnackBarType.error,
      );
    }
  }

  void _handleFirebaseAuthError(FirebaseAuthException e) {
    if (!mounted) return;

    String message;
    switch (e.code) {
      case 'email-already-in-use':
        message = 'This email is already registered';
        break;
      case 'invalid-email':
        message = 'Invalid email address';
        break;
      case 'operation-not-allowed':
        message = 'Email/password accounts are not enabled';
        break;
      case 'weak-password':
        message = 'Password is too weak';
        break;
      default:
        message = e.message ?? 'Registration failed';
    }

    DelHelperFunctions.showSnackBar(
      context: context,
      message: message,
      type: SnackBarType.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.status == RegisterStatus.success) {
          DelHelperFunctions.showSnackBar(
              context: context,
              message: state.message,
              type: SnackBarType.success);

          DelHelperFunctions.navigateReplacementToScreen(context, LoginView());
        } else if (state.status == RegisterStatus.failure) {
          DelHelperFunctions.showSnackBar(
              context: context,
              message: state.message,
              type: SnackBarType.error);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    validator: (value) => value?.isEmpty ?? true
                        ? 'First name is required'
                        : null,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.user),
                      labelText: DelTexts.firstName,
                    ),
                  ),
                ),
                const SizedBox(width: DelSizes.spaceBtwInputFields),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Last name is required' : null,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.user),
                      labelText: DelTexts.lastName,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DelSizes.spaceBtwInputFields),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              validator: (value) {
                return TValidator.validateEmail(value);
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct),
                labelText: DelTexts.email,
              ),
            ),
            const SizedBox(height: DelSizes.spaceBtwInputFields),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: _phoneController,
              validator: (value) => TValidator.validatePhoneNumber(value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.call),
                labelText: DelTexts.phoneNo,
              ),
            ),
            const SizedBox(height: DelSizes.spaceBtwInputFields),
            TextFormField(
              keyboardType: TextInputType.streetAddress,
              controller: _addressController,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Address is required' : null,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.location),
                labelText: 'Address',
              ),
            ),
            const SizedBox(height: DelSizes.spaceBtwInputFields),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              controller: _passwordController,
              validator: (value) => TValidator.validatePassword(value),
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Iconsax.eye_slash : Iconsax.eye,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                labelText: DelTexts.password,
              ),
            ),
            const SizedBox(height: DelSizes.spaceBtwInputFields),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              controller: _confirmPasswordController,
              validator: (value) => TValidator.validateConfirmPassword(
                  value, _passwordController),
              obscureText: _obscurePassword,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.password_check),
                labelText: 'Confirm Password',
              ),
            ),
            const SizedBox(height: DelSizes.spaceBtwInputFields),
            const TermsAndPrivacyAgreement(),
            const SizedBox(height: DelSizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: BlocBuilder<RegisterCubit, RegisterState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state.status == RegisterStatus.loading
                        ? null
                        : () {
                            DelHelperFunctions.hideKeyboard();
                            _handleRegistration();
                          },
                    child: state.status == RegisterStatus.loading
                        ? const Text(DelTexts.loading)
                        : const Text(DelTexts.createAccount),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
