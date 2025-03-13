import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:async';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_strings.dart';
import '../bloc/auth_bloc.dart';
import 'terms_and_privacy_agreement.dart';
import '../../../home/presentation/screens/home_screen.dart';

class StudentSignupForm extends StatefulWidget {
  const StudentSignupForm({Key? key}) : super(key: key);

  @override
  State<StudentSignupForm> createState() => _StudentSignupFormState();
}

class _StudentSignupFormState extends State<StudentSignupForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  OverlayEntry? _overlayEntry;
  Timer? _notificationTimer;

  // Teks controllers
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nimController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State variables
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  // Dropdown state
  bool _isProdiDropdownOpen = false;
  bool _isAngkatanDropdownOpen = false;

  // Focus nodes for tracking dropdown state
  final _prodiFocusNode = FocusNode();
  final _angkatanFocusNode = FocusNode();

  // Dropdown options
  String? _selectedProdi;
  String? _selectedAngkatan;

  // Program studi options berdasarkan fakultas (untuk backend)
  final Map<String, String> _prodiToFakultas = {
    // Fakultas Informatika dan Teknik Elektro (FITE)
    'S1 Informatika': 'FITE',
    'S1 Sistem Informasi': 'FITE',
    'S1 Teknik Elektro': 'FITE',

    // Fakultas Teknik Industri (FTI)
    'S1 Manajemen Rekayasa': 'FTI',
    'S1 Teknik Metalurgi': 'FTI',

    // Fakultas VOKASI
    'D4 Teknologi Rekayasa Perangkat Lunak': 'VOKASI',
    'D3 Teknologi Informasi': 'VOKASI',
    'D3 Teknologi Komputer': 'VOKASI',

    // Fakultas Bioteknologi
    'S1 Teknik Bioproses': 'Bioteknologi',
  };

  // Program studi options
  final List<String> _prodiOptions = [
    // Fakultas Informatika dan Teknik Elektro (FITE)
    'S1 Informatika',
    'S1 Sistem Informasi',
    'S1 Teknik Elektro',

    // Fakultas Teknik Industri (FTI)
    'S1 Manajemen Rekayasa',
    'S1 Teknik Metalurgi',

    // Fakultas VOKASI
    'D4 Teknologi Rekayasa Perangkat Lunak',
    'D3 Teknologi Informasi',
    'D3 Teknologi Komputer',

    // Fakultas Bioteknologi
    'S1 Teknik Bioproses',
  ];

  // Angkatan options
  final List<String> _angkatanOptions = [
    '2019',
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
  ];

  @override
  void initState() {
    super.initState();
    _prodiFocusNode.addListener(_handleProdiFocusChange);
    _angkatanFocusNode.addListener(_handleAngkatanFocusChange);

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    // Removed notification popup
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      final fullName = [
        _firstNameController.text,
        _middleNameController.text,
        _lastNameController.text,
      ].where((name) => name.isNotEmpty).join(' ');

      context.read<AuthBloc>().add(
            RegisterEvent(
              nimNip: _nimController.text,
              name: fullName,
              email: _emailController.text,
              password: _passwordController.text,
              userType: 'student',
            ),
          );
    }
  }

  // Method to show notification popup
  void _showNotificationPopup() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: MediaQuery.of(context).size.height * 0.03,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, -3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Iconsax.info_circle,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Silakan isi formulir untuk mendaftar sebagai Mahasiswa',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: _removeNotificationPopup,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              splashRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    // Add overlay to screen
    Overlay.of(context).insert(_overlayEntry!);

    // Start fade in animation
    _animationController.forward();

    // Set timer to remove notification after 5 seconds
    _notificationTimer = Timer(const Duration(seconds: 5), () {
      _removeNotificationPopup();
    });
  }

  // Method to remove notification with animation
  void _removeNotificationPopup() {
    if (_overlayEntry != null && _animationController.isCompleted) {
      _animationController.reverse().then((_) {
        if (_overlayEntry != null) {
          _overlayEntry!.remove();
          _overlayEntry = null;
        }
      });
    }
  }

  void _handleProdiFocusChange() {
    setState(() {
      _isProdiDropdownOpen = _prodiFocusNode.hasFocus;
    });
  }

  void _handleAngkatanFocusChange() {
    setState(() {
      _isAngkatanDropdownOpen = _angkatanFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _nimController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _prodiFocusNode.removeListener(_handleProdiFocusChange);
    _angkatanFocusNode.removeListener(_handleAngkatanFocusChange);
    _prodiFocusNode.dispose();
    _angkatanFocusNode.dispose();

    // Dispose animation resources
    _animationController.dispose();
    _notificationTimer?.cancel();

    // Remove overlay if still present
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: isSmallScreen ? AppSizes.sm : AppSizes.md,
      ),
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
      labelStyle: TextStyle(
        color: AppColors.darkGrey,
        fontSize: isSmallScreen ? 13 : 14,
      ),
      hintStyle: TextStyle(
        color: AppColors.darkGrey.withOpacity(0.7),
        fontSize: isSmallScreen ? 12 : 14,
      ),
      errorMaxLines: 5, // Allow multiple lines for error messages
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
                content: Text(state.message ?? 'Registration successful'),
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
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.spaceBtwItems),
                // 1. Nama Depan dan Nama Tengah (opsional) dalam satu baris - IMPROVED VERSION
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama Depan - menggunakan 50% lebar
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: inputDecoration.copyWith(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal:
                                isSmallScreen ? AppSizes.sm : AppSizes.md,
                            vertical: isSmallScreen ? AppSizes.sm : AppSizes.md,
                          ),
                          labelText: 'Nama Depan',
                          hintText: 'Nama depan',
                          hintStyle: TextStyle(
                            fontSize: isSmallScreen ? 11 : 12,
                            color: AppColors.darkGrey.withOpacity(0.6),
                          ),
                          prefixIcon: Icon(
                            Iconsax.user,
                            color: AppColors.darkGrey,
                            size: isSmallScreen ? 18 : 22,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13 : 14,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppTexts.requiredField;
                          }
                          if (value.length < 2) {
                            return 'Nama depan minimal 2 karakter';
                          }
                          return null;
                        },
                      ),
                    ),

                    // Spacing
                    SizedBox(
                        width: isSmallScreen
                            ? AppSizes.sm
                            : AppSizes.spaceBtwInputFields),

                    // Nama Tengah (opsional) - menggunakan 50% lebar
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _middleNameController,
                        decoration: inputDecoration.copyWith(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal:
                                isSmallScreen ? AppSizes.sm : AppSizes.md,
                            vertical: isSmallScreen ? AppSizes.sm : AppSizes.md,
                          ),
                          labelText: 'Nama Tengah',
                          hintText: 'Tengah',
                          helperText: null,
                          labelStyle: TextStyle(
                            color: AppColors.darkGrey.withOpacity(0.8),
                            fontSize: isSmallScreen ? 13 : 14,
                          ),
                          prefixIcon: Icon(
                            Iconsax.user,
                            color: AppColors.darkGrey.withOpacity(0.7),
                            size: isSmallScreen ? 18 : 22,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                AppSizes.inputFieldRadius),
                            borderSide: BorderSide(
                                color: AppColors.grey.withOpacity(0.7)),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13 : 14,
                        ),
                        // No validator needed since it's optional
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceBtwInputFields),

                // 2. Nama Belakang
                TextFormField(
                  controller: _lastNameController,
                  decoration: inputDecoration.copyWith(
                    labelText: 'Nama Belakang',
                    hintText: 'Masukkan nama belakang',
                    hintStyle: TextStyle(
                      fontSize: isSmallScreen ? 11 : 12,
                      color: AppColors.darkGrey.withOpacity(0.6),
                    ),
                    prefixIcon: Icon(
                      Iconsax.user,
                      color: AppColors.darkGrey,
                      size: isSmallScreen ? 18 : 22,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppTexts.requiredField;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.spaceBtwInputFields),

                // 3. Email (@del.ac.id)
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: inputDecoration.copyWith(
                    labelText: 'Email Kampus',
                    hintText: 'nama@students.del.ac.id',
                    prefixIcon: Icon(
                      Iconsax.sms,
                      color: AppColors.darkGrey,
                      size: isSmallScreen ? 18 : 20,
                    ),
                    helperText:
                        'Gunakan email resmi mahasiswa Institut Teknologi Del',
                    helperStyle: TextStyle(
                      color: AppColors.darkGrey.withOpacity(0.7),
                      fontSize: isSmallScreen ? 10 : 11,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppTexts.requiredField;
                    }
                    if (!value.endsWith('@students.del.ac.id')) {
                      return 'Gunakan format nama@students.del.ac.id';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.spaceBtwInputFields),

                // 4. NIM
                TextFormField(
                  controller: _nimController,
                  keyboardType: TextInputType
                      .text, // Changed to text to allow alphanumeric
                  decoration: inputDecoration.copyWith(
                    labelText: 'NIM',
                    hintText: 'contoh: 11S20999',
                    prefixIcon: Icon(
                      Iconsax.card,
                      color: AppColors.darkGrey,
                      size: isSmallScreen ? 18 : 22,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppTexts.requiredField;
                    }
                    if (value.length < 6 || value.length > 8) {
                      return 'NIM harus terdiri dari 6-8 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.spaceBtwInputFields),

                // 6. Program Studi (dropdown) - SIMPLIFIED STYLING
                GestureDetector(
                  onTap: () {
                    _showProdiBottomSheet(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AppSizes.inputFieldRadius),
                      color: Colors.white,
                      border: Border.all(color: AppColors.grey),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    height: 60, // Fixed height
                    child: Row(
                      children: [
                        // Program Studi Text and Icon
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Icon(
                                  Iconsax.book,
                                  color: AppColors.darkGrey,
                                  size: 22,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Program Studi',
                                        style: TextStyle(
                                          color: AppColors.darkGrey,
                                          fontSize: 14,
                                        ),
                                      ),
                                      _selectedProdi != null
                                          ? Text(
                                              _selectedProdi!,
                                              style: TextStyle(
                                                color: AppColors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Arrow Icon
                        Padding(
                          padding: const EdgeInsets.only(right: 24.0),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.grey,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Hidden dropdown for validation and function (Program Studi)
                Container(
                  height: 0,
                  child: Opacity(
                    opacity: 0,
                    child: DropdownButtonFormField<String>(
                      value: _selectedProdi,
                      items: _prodiOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedProdi = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppTexts.requiredField;
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.spaceBtwInputFields),

                // 7. Angkatan - SIMPLIFIED STYLING
                GestureDetector(
                  onTap: () {
                    _showAngkatanBottomSheet(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AppSizes.inputFieldRadius),
                      color: Colors.white,
                      border: Border.all(color: AppColors.grey),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    height: 60, // Fixed height
                    child: Row(
                      children: [
                        // Angkatan Text and Icon
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Icon(
                                  Iconsax.calendar_1,
                                  color: AppColors.darkGrey,
                                  size: 22,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Angkatan',
                                        style: TextStyle(
                                          color: AppColors.darkGrey,
                                          fontSize: 14,
                                        ),
                                      ),
                                      _selectedAngkatan != null
                                          ? Text(
                                              _selectedAngkatan!,
                                              style: TextStyle(
                                                color: AppColors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Arrow Icon
                        Padding(
                          padding: const EdgeInsets.only(right: 24.0),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.grey,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Hidden dropdown for validation and function (Angkatan)
                Container(
                  height: 0,
                  child: Opacity(
                    opacity: 0,
                    child: DropdownButtonFormField<String>(
                      value: _selectedAngkatan,
                      items: _angkatanOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedAngkatan = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppTexts.requiredField;
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.spaceBtwInputFields),

                // 5. Kata Sandi
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: inputDecoration.copyWith(
                    labelText: AppTexts.password,
                    hintText:
                        'Minimal 8 karakter dengan huruf besar, angka & simbol',
                    prefixIcon: Icon(
                      Iconsax.password_check,
                      color: AppColors.darkGrey,
                      size: isSmallScreen ? 18 : 22,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword ? Iconsax.eye_slash : Iconsax.eye,
                        color: AppColors.darkGrey,
                        size: isSmallScreen ? 18 : 20,
                      ),
                    ),
                  ),
                  validator: _validatePassword,
                ),
                const SizedBox(height: AppSizes.spaceBtwInputFields),

                // 5. Konfirmasi Kata Sandi
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: inputDecoration.copyWith(
                    labelText: AppTexts.confirmPassword,
                    hintText: 'Konfirmasi kata sandi Anda',
                    prefixIcon: Icon(
                      Iconsax.password_check,
                      color: AppColors.darkGrey,
                      size: isSmallScreen ? 18 : 22,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Iconsax.eye_slash
                            : Iconsax.eye,
                        color: AppColors.darkGrey,
                        size: isSmallScreen ? 18 : 20,
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

                // Syarat dan Ketentuan
                TermsAndPrivacyAgreement(
                  value: _agreeToTerms,
                  onChanged: (value) {
                    setState(() {
                      _agreeToTerms = value ?? false;
                    });
                  },
                ),
                const SizedBox(height: AppSizes.md),

                // Tombol Daftar
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _agreeToTerms
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          AppTexts.signUp,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
                const SizedBox(height: AppSizes.spaceBtwSections),

                // Sudah memiliki akun
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppTexts.alreadyHaveAccount,
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          AppTexts.signIn,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.spaceBtwItems),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to show enhanced bottom sheet for program studi
  void _showProdiBottomSheet(BuildContext context) {
    final size = MediaQuery.of(context).size;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: size.height * 0.65,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          offset: const Offset(0, 1),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Iconsax.book_1,
                                    color: AppColors.primary,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Pilih Program Studi',
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.grey[600],
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        // FITE
                        _buildFakultasSection(
                          context,
                          'Fakultas Informatika dan Teknik Elektro',
                          [
                            'S1 Informatika',
                            'S1 Sistem Informasi',
                            'S1 Teknik Elektro',
                          ],
                          setModalState,
                        ),

                        // FTI
                        _buildFakultasSection(
                          context,
                          'Fakultas Teknik Industri',
                          [
                            'S1 Manajemen Rekayasa',
                            'S1 Teknik Metalurgi',
                          ],
                          setModalState,
                        ),

                        // Vokasi
                        _buildFakultasSection(
                          context,
                          'Fakultas Vokasi',
                          [
                            'D4 Teknologi Rekayasa Perangkat Lunak',
                            'D3 Teknologi Informasi',
                            'D3 Teknologi Komputer',
                          ],
                          setModalState,
                        ),

                        // Bioteknologi
                        _buildFakultasSection(
                          context,
                          'Fakultas Bioteknologi',
                          [
                            'S1 Teknik Bioproses',
                          ],
                          setModalState,
                        ),

                        // Extra space at bottom for better UX
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Helper method untuk membuat section fakultas pada bottom sheet
  Widget _buildFakultasSection(BuildContext context, String fakultasTitle,
      List<String> prodiList, StateSetter setModalState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header fakultas
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            fakultasTitle,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Program studi list
        ...prodiList.map((prodi) {
          final isSelected = _selectedProdi == prodi;
          return InkWell(
            onTap: () {
              // Update both local and parent state
              setModalState(() {
                _selectedProdi = prodi;
              });
              setState(() {
                _selectedProdi = prodi;
              });
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.05)
                    : Colors.transparent,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      prodi,
                      style: TextStyle(
                        color: isSelected ? AppColors.primary : Colors.black87,
                        fontSize: 15,
                        fontWeight:
                            isSelected ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                      size: 20,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  // Method untuk menampilkan bottom sheet angkatan
  void _showAngkatanBottomSheet(BuildContext context) {
    final size = MediaQuery.of(context).size;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: size.height * 0.5,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          offset: const Offset(0, 1),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Iconsax.calendar_1,
                                color: AppColors.primary,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Pilih Tahun Angkatan',
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.grey[600],
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Angkatan list
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _angkatanOptions.length,
                      itemBuilder: (context, index) {
                        final angkatan = _angkatanOptions[index];
                        final isSelected = _selectedAngkatan == angkatan;

                        return InkWell(
                          onTap: () {
                            // Update both local and parent state
                            setModalState(() {
                              _selectedAngkatan = angkatan;
                            });
                            setState(() {
                              _selectedAngkatan = angkatan;
                            });

                            // Close bottom sheet and force parent rebuild
                            Navigator.pop(context);

                            // Force the hidden dropdown to update for validation
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {});
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withOpacity(0.05)
                                  : Colors.transparent,
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    angkatan,
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.black87,
                                      fontSize: 15,
                                      fontWeight: isSelected
                                          ? FontWeight.w500
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Password validation with improved visual formatting
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppTexts.requiredField;
    }

    List<String> requirements = [];

    if (value.length < 8) {
      requirements.add('• Minimal 8 karakter');
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      requirements.add('• Minimal 1 huruf besar (A-Z)');
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      requirements.add('• Minimal 1 angka (0-9)');
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      requirements.add('• Minimal 1 karakter khusus (!@#\$%^&*)');
    }

    if (requirements.isEmpty) {
      return null;
    } else {
      return 'Password harus memenuhi kriteria berikut:\n' +
          requirements.join('\n');
    }
  }
}
