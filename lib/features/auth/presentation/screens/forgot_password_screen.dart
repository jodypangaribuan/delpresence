import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_strings.dart';
import '../screens/verification_code_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Swipe back animation variables
  double _dragStartX = 0.0;
  double _dragDistance = 0.0;
  bool _isDraggingHorizontally = false;

  // Handle the swipe back gesture
  void _handleHorizontalDragStart(DragStartDetails details) {
    _dragStartX = details.localPosition.dx;
    setState(() {
      _isDraggingHorizontally = true;
      _dragDistance = 0;
    });
  }

  void _handleHorizontalDragUpdate(DragUpdateDetails details) {
    if (_isDraggingHorizontally) {
      final newDragDistance = details.localPosition.dx - _dragStartX;
      if (newDragDistance > 0) {
        // Only track right swipes
        setState(() {
          // Limit the drag to screen width
          _dragDistance =
              newDragDistance.clamp(0, MediaQuery.of(context).size.width);
        });
      }
    }
  }

  void _handleHorizontalDragEnd(DragEndDetails details) {
    if (_isDraggingHorizontally) {
      if (_dragDistance > MediaQuery.of(context).size.width / 3) {
        // Return to the previous screen once the drag reaches the threshold
        Navigator.of(context).pop();
      } else {
        // Not enough, animate back to original position
        setState(() {
          _dragDistance = 0;
          _isDraggingHorizontally = false;
        });
      }
    }
  }

  // Method untuk menutup keyboard
  void _unfocusKeyboard() {
    FocusScope.of(context).unfocus();
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

    // Get screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: WillPopScope(
        onWillPop: () async {
          return true; // Allow back navigation
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // Background layer - just a plain white screen
              Positioned.fill(
                child: Container(
                  color: Colors.white,
                ),
              ),

              // Main screen with gesture detector - using Transform instead of Positioned
              Transform.translate(
                offset: Offset(_dragDistance, 0),
                child: SizedBox(
                  width: screenWidth, // Ensure full width
                  height: screenHeight, // Ensure full height
                  child: GestureDetector(
                    onHorizontalDragStart: _handleHorizontalDragStart,
                    onHorizontalDragUpdate: _handleHorizontalDragUpdate,
                    onHorizontalDragEnd: _handleHorizontalDragEnd,
                    onTap: _unfocusKeyboard,
                    child: Material(
                      elevation: 8,
                      color: Colors.white,
                      shadowColor: Colors.black.withOpacity(0.2),
                      child: Scaffold(
                        backgroundColor: AppColors.white,
                        appBar: AppBar(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          systemOverlayStyle: const SystemUiOverlayStyle(
                            statusBarColor: Colors.transparent,
                            statusBarIconBrightness: Brightness.dark,
                          ),
                          leading: IconButton(
                            icon: const Icon(Iconsax.arrow_left,
                                color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        body: SafeArea(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Container(
                              padding:
                                  const EdgeInsets.all(AppSizes.defaultSpace),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // SVG Illustration centered - positioned above the title
                                  Center(
                                    child: SvgPicture.asset(
                                      'assets/images/background/forgot-password.svg',
                                      height: screenHeight * 0.35,
                                      width: screenWidth * 0.9,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: AppSizes.md),

                                  // Title
                                  Text(
                                    AppTexts.forgotPasswordTitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.black,
                                        ),
                                  ),
                                  const SizedBox(height: AppSizes.sm),

                                  // Subtitle
                                  Text(
                                    AppTexts.forgotPasswordSubtitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.darkGrey,
                                        ),
                                  ),
                                  const SizedBox(
                                      height: AppSizes.spaceBtwSections),

                                  // Form
                                  Form(
                                    child: Column(
                                      children: [
                                        // Email Field
                                        TextFormField(
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            labelText: AppTexts.email,
                                            labelStyle: TextStyle(
                                                color: AppColors.darkGrey),
                                            prefixIcon: Icon(Iconsax.message,
                                                color: AppColors.darkGrey),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(AppSizes
                                                      .inputFieldRadius),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(AppSizes
                                                      .inputFieldRadius),
                                              borderSide: BorderSide(
                                                  color: AppColors.grey),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(AppSizes
                                                      .inputFieldRadius),
                                              borderSide: BorderSide(
                                                  color: AppColors.primary),
                                            ),
                                            filled: true,
                                            fillColor: AppColors.lightGrey
                                                .withOpacity(0.1),
                                            hintText:
                                                "Enter your institutional email (@students.del.ac.id or @del.ac.id)",
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return AppTexts.requiredField;
                                            }

                                            // Check for valid DEL institutional email format
                                            bool isValidInstitutionalEmail =
                                                value.endsWith(
                                                        '@students.del.ac.id') ||
                                                    value
                                                        .endsWith('@del.ac.id');

                                            if (!isValidInstitutionalEmail) {
                                              return "Please enter a valid institutional email address (@students.del.ac.id or @del.ac.id)";
                                            }

                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                            height:
                                                AppSizes.spaceBtwInputFields),

                                        // Submit Button
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Navigate to verification code screen
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const VerificationCodeScreen(),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primary,
                                              foregroundColor: AppColors.white,
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppSizes.buttonRadius),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: AppSizes
                                                          .buttonHeight),
                                            ),
                                            child: Text(
                                              AppTexts.submit.toUpperCase(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                            height: AppSizes.spaceBtwItems),

                                        // Back to Login
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(
                                            AppTexts.backToLogin,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
