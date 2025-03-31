import 'package:delpresence/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:ui' as ui;
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_strings.dart';
import '../bloc/auth_bloc.dart';
import '../../domain/repositories/auth_repository.dart';

class LoginFormSection extends StatefulWidget {
  const LoginFormSection({Key? key}) : super(key: key);

  @override
  State<LoginFormSection> createState() => _LoginFormSectionState();
}

class _LoginFormSectionState extends State<LoginFormSection> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false; // Default to false for security
  bool _isLoading = false;
  bool _showStudentOnlyWarning = false;
  bool _showCredentialsWarning = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // We need to delay this call to get the context in initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedCredentials();
    });
  }

  Future<void> _loadSavedCredentials() async {
    // Check if the context is still valid (widget is still mounted)
    if (!mounted) return;

    final authRepository = context.read<AuthBloc>().repository;

    try {
      // Load remember me setting
      final rememberMe = await authRepository.getRememberMe();

      // If remember me is enabled, try to load saved credentials
      if (rememberMe) {
        final savedCredentials = await authRepository.getSavedCredentials();

        if (savedCredentials != null && mounted) {
          setState(() {
            _usernameController.text = savedCredentials['username'] ?? '';
            _passwordController.text = savedCredentials['password'] ?? '';
            _rememberMe = true;
          });

          print('Loaded saved credentials for: ${_usernameController.text}');
        }
      }

      // Mark as initialized after loading
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      print('Error loading saved credentials: $e');
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;

      // Reset warnings when attempting new login
      setState(() {
        _showStudentOnlyWarning = false;
        _showCredentialsWarning = false;
      });

      // Save credentials if remember me is checked
      context.read<AuthBloc>().repository.saveCredentials(
            username,
            password,
            _rememberMe,
          );

      context.read<AuthBloc>().add(
            LoginEvent(
              username: username,
              password: password,
            ),
          );
    }
  }

  void _showForgotPasswordMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fitur lupa kata sandi tidak tersedia saat ini.'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Don't render until initialization is complete
    if (!_isInitialized) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // Define common input decoration to maintain consistency
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

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state is AuthLoading;
        });

        if (state is AuthError) {
          // Add diagnostic logging
          print('Auth Error: ${state.message}');

          // Check if this is an access denied error
          if (state.message.startsWith('ACCESS_DENIED:')) {
            print('Showing student-only warning');
            setState(() {
              _showStudentOnlyWarning = true;
              _showCredentialsWarning = false;
            });
            // Do not show snackbar for access denied and don't navigate to home screen
          } else if (state.message == 'Username atau password salah' ||
              state.message.toLowerCase().contains('invalid credentials') ||
              state.message.toLowerCase().contains('authentication failed')) {
            // Handle all variations of credential errors
            print('Showing credentials warning for: ${state.message}');
            // Show credentials warning banner
            setState(() {
              _showCredentialsWarning = true;
              _showStudentOnlyWarning = false;
            });
          } else {
            print('Showing general error snackbar: ${state.message}');
            setState(() {
              _showCredentialsWarning = false;
              _showStudentOnlyWarning = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        }

        if (state is AuthSuccess) {
          print('Authentication successful, navigating to home');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student-only warning banner - only shown when non-student tries to login
            if (_showStudentOnlyWarning)
              Container(
                margin: const EdgeInsets.only(
                    bottom: AppSizes.spaceBtwSections * 0.8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.warning,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.info_circle,
                      color: AppColors.warning,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Aplikasi ini hanya dapat digunakan oleh mahasiswa aktif Institut Teknologi Del.',
                        style: TextStyle(
                          color: AppColors.black.withOpacity(0.8),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Invalid credentials warning banner - shown when username or password is incorrect
            if (_showCredentialsWarning)
              Container(
                margin: const EdgeInsets.only(
                    bottom: AppSizes.spaceBtwSections * 0.8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.error,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.info_circle,
                      color: AppColors.error,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Username atau password yang Anda masukkan salah. Silakan coba lagi.',
                        style: TextStyle(
                          color: AppColors.black.withOpacity(0.8),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Username Field with animation
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppSizes.inputFieldRadius),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _usernameController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  cursorColor: AppColors.primary,
                  cursorWidth: 1.5,
                  cursorRadius: const Radius.circular(2),
                  decoration: inputDecoration.copyWith(
                    labelText: "Username",
                    hintText: "Masukkan username Anda",
                    prefixIcon: Container(
                      margin: const EdgeInsets.only(left: 12, right: 8),
                      child: Icon(
                        Iconsax.user,
                        color: AppColors.primary,
                        size: AppSizes.iconMd,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 50,
                      minHeight: 50,
                    ),
                    labelStyle: TextStyle(
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    hintStyle: TextStyle(
                      color: AppColors.darkGrey.withOpacity(0.5),
                      fontSize: 13,
                    ),
                    floatingLabelStyle: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppTexts.requiredField;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // Auto validate after user starts typing
                    _formKey.currentState?.validate();
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spaceBtwInputFields),

            // Password Field with animation
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600), // slightly delayed
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppSizes.inputFieldRadius),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleLogin(),
                  cursorColor: AppColors.primary,
                  cursorWidth: 1.5,
                  cursorRadius: const Radius.circular(2),
                  decoration: inputDecoration.copyWith(
                    labelText: AppTexts.password,
                    hintText: AppTexts.passwordHint,
                    prefixIcon: Container(
                      margin: const EdgeInsets.only(left: 12, right: 8),
                      child: Icon(
                        Iconsax.lock,
                        color: AppColors.primary,
                        size: AppSizes.iconMd,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 50,
                      minHeight: 50,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Iconsax.eye_slash : Iconsax.eye,
                        color: AppColors.darkGrey,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    labelStyle: TextStyle(
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    hintStyle: TextStyle(
                      color: AppColors.darkGrey.withOpacity(0.5),
                      fontSize: 13,
                    ),
                    floatingLabelStyle: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppTexts.requiredField;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // Auto validate after user starts typing
                    _formKey.currentState?.validate();
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spaceBtwInputFields / 2),

            // Remember Me & Forgot Password with animation
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 700), // even more delayed
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: child,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Remember Me
                  Row(
                    children: [
                      Transform.scale(
                        scale: 0.9,
                        child: Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });

                            // If unchecked, clear saved credentials
                            if (value == false) {
                              context
                                  .read<AuthBloc>()
                                  .repository
                                  .clearCredentials();
                            }
                          },
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      Text(
                        AppTexts.rememberMe,
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // Forgot Password
                  TextButton(
                    onPressed: _showForgotPasswordMessage,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(0, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      AppTexts.forgotPassword,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.spaceBtwSections),

            // Login Button with animation
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800), // most delayed
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSizes.buttonHeight,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.buttonRadius),
                    ),
                    elevation: 3,
                    shadowColor: AppColors.primary.withOpacity(0.3),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          AppTexts.loginButton,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
