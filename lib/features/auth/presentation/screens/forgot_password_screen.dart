import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../screens/verification_code_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Form key and controllers
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  // Swipe back animation variables
  double _dragStartX = 0.0;
  double _dragDistance = 0.0;
  bool _isDraggingHorizontally = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

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

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });

        // Navigate to verification code screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const VerificationCodeScreen(),
          ),
        );
      });
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

    // Get screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Configure input decoration similar to login page
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.md + 2,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: BorderSide(color: AppColors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: BorderSide(color: AppColors.grey.withOpacity(0.7)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      errorStyle: TextStyle(
        color: AppColors.error,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      errorMaxLines: 3,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      isDense: true,
    );

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
              // Background layer with gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        AppColors.background.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
              ),

              // Main screen with gesture detector
              Transform.translate(
                offset: Offset(_dragDistance, 0),
                child: SizedBox(
                  width: screenWidth,
                  height: screenHeight,
                  child: GestureDetector(
                    onHorizontalDragStart: _handleHorizontalDragStart,
                    onHorizontalDragUpdate: _handleHorizontalDragUpdate,
                    onHorizontalDragEnd: _handleHorizontalDragEnd,
                    onTap: _unfocusKeyboard,
                    child: Material(
                      elevation: 0,
                      color: Colors.transparent,
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
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
                          title: Text(
                            "Lupa Password",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                          ),
                          centerTitle: true,
                        ),
                        body: SafeArea(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Container(
                              padding:
                                  const EdgeInsets.all(AppSizes.defaultSpace),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // SVG Illustration centered
                                  SvgPicture.asset(
                                    'assets/images/background/forgot-password.svg',
                                    height: screenHeight * 0.3,
                                    width: screenWidth * 0.9,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(
                                      height: AppSizes.spaceBtwSections),

                                  // Title
                                  Text(
                                    "Atur Ulang Password",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.black,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: AppSizes.sm),

                                  // Subtitle
                                  Text(
                                    "Masukkan email Anda untuk menerima tautan reset password",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.darkGrey,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                      height: AppSizes.spaceBtwSections),

                                  // Form
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        // Email Field with custom error container
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                AppSizes.inputFieldRadius),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.primary
                                                    .withOpacity(0.08),
                                                blurRadius: 12,
                                                offset: const Offset(0, 3),
                                                spreadRadius: 0,
                                              ),
                                            ],
                                          ),
                                          child: TextFormField(
                                            controller: _emailController,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            textInputAction:
                                                TextInputAction.done,
                                            cursorColor: AppColors.primary,
                                            cursorWidth: 1.5,
                                            cursorRadius:
                                                const Radius.circular(2),
                                            decoration:
                                                inputDecoration.copyWith(
                                              labelText: "Email",
                                              hintText:
                                                  "Masukkan email institusi Anda",
                                              prefixIcon: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 12, right: 8),
                                                child: Icon(
                                                  Iconsax.message,
                                                  color: AppColors.primary,
                                                  size: AppSizes.iconMd,
                                                ),
                                              ),
                                              prefixIconConstraints:
                                                  const BoxConstraints(
                                                minWidth: 50,
                                                minHeight: 50,
                                              ),
                                              labelStyle: TextStyle(
                                                color: AppColors.darkGrey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                              hintStyle: TextStyle(
                                                color: AppColors.darkGrey
                                                    .withOpacity(0.5),
                                                fontSize: 13,
                                              ),
                                              floatingLabelStyle: TextStyle(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                              // Now using regular error style that displays below the field
                                              errorStyle: TextStyle(
                                                color: AppColors.error,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                height: 1.2,
                                              ),
                                              errorMaxLines: 3,
                                            ),
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Email tidak boleh kosong";
                                              }

                                              // Check for valid DEL institutional email format
                                              bool isValidInstitutionalEmail =
                                                  value.endsWith(
                                                          '@students.del.ac.id') ||
                                                      value.endsWith(
                                                          '@del.ac.id');

                                              if (!isValidInstitutionalEmail) {
                                                return "Masukkan email institusi yang valid\n(@students.del.ac.id atau @del.ac.id)";
                                              }

                                              return null;
                                            },
                                            onFieldSubmitted: (_) =>
                                                _handleSubmit(),
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                          ),
                                        ),
                                        const SizedBox(
                                            height: AppSizes.spaceBtwSections),

                                        // Submit Button
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: _isLoading
                                                ? null
                                                : _handleSubmit,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primary,
                                              foregroundColor: AppColors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppSizes.buttonRadius),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: AppSizes
                                                          .buttonHeight),
                                              disabledBackgroundColor: AppColors
                                                  .primary
                                                  .withOpacity(0.6),
                                              disabledForegroundColor:
                                                  Colors.white,
                                            ),
                                            child: _isLoading
                                                ? const SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                                  )
                                                : const Text(
                                                    "KIRIM EMAIL RESET",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1.2,
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
                                            "Kembali ke halaman login",
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
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
