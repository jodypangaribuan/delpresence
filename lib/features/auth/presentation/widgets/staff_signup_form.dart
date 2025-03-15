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

class StaffSignupForm extends StatefulWidget {
  const StaffSignupForm({Key? key}) : super(key: key);

  @override
  State<StaffSignupForm> createState() => _StaffSignupFormState();
}

class _StaffSignupFormState extends State<StaffSignupForm>
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
  final _nipController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State variables
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  // Dropdown state
  bool _isJabatanDropdownOpen = false;

  // Focus nodes for tracking dropdown state
  final _jabatanFocusNode = FocusNode();

  // Dropdown options
  String? _selectedJabatan;

  // Jabatan fungsional options
  final List<String> _jabatanOptions = [
    'Tenaga Pengajar',
    'Asisten Ahli',
    'Lektor',
    'Lektor Kepala',
    'Guru Besar',
  ];

  @override
  void initState() {
    super.initState();
    _jabatanFocusNode.addListener(_handleJabatanFocusChange);

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

  void _handleJabatanFocusChange() {
    setState(() {
      _isJabatanDropdownOpen = _jabatanFocusNode.hasFocus;
    });
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
              nimNip: _nipController.text,
              name: fullName,
              email: _emailController.text,
              password: _passwordController.text,
              userType: 'staff',
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
                                'Silakan isi formulir untuk mendaftar sebagai Dosen/TA',
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

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _nipController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _jabatanFocusNode.removeListener(_handleJabatanFocusChange);
    _jabatanFocusNode.dispose();

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
      contentPadding: EdgeInsets.all(isSmallScreen ? AppSizes.sm : AppSizes.md),
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
        fontSize: isSmallScreen ? 12 : 14,
      ),
      hintStyle: TextStyle(
        fontSize: isSmallScreen ? 11 : 12,
        color: AppColors.darkGrey.withOpacity(0.6),
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
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? AppSizes.md : AppSizes.defaultSpace,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSizes.spaceBtwItems),
              // 1. Nama Depan dan Nama Tengah (opsional) dalam satu baris
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
                          horizontal: isSmallScreen ? AppSizes.sm : AppSizes.md,
                          vertical: isSmallScreen ? AppSizes.sm : AppSizes.md,
                        ),
                        labelText: 'Nama Depan',
                        hintText: 'Nama depan',
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
                          horizontal: isSmallScreen ? AppSizes.sm : AppSizes.md,
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
                          borderRadius:
                              BorderRadius.circular(AppSizes.inputFieldRadius),
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
                  hintText: 'nama@del.ac.id',
                  prefixIcon: Icon(
                    Iconsax.sms,
                    color: AppColors.darkGrey,
                    size: isSmallScreen ? 18 : 22,
                  ),
                  helperText: 'Gunakan email resmi Institut Teknologi Del',
                  helperStyle: TextStyle(
                    color: AppColors.darkGrey.withOpacity(0.7),
                    fontSize: isSmallScreen ? 10 : 12,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppTexts.requiredField;
                  }
                  if (!value.endsWith('@del.ac.id')) {
                    return 'Gunakan email dengan domain @del.ac.id';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.spaceBtwInputFields),

              // 4. NIP
              TextFormField(
                controller: _nipController,
                keyboardType: TextInputType.text,
                decoration: inputDecoration.copyWith(
                  labelText: 'NIP',
                  hintText: 'Masukkan NIP Anda',
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
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.spaceBtwInputFields),

              // 5. Jabatan Fungsional (dropdown)
              GestureDetector(
                onTap: () {
                  _showJabatanBottomSheet(context);
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
                      // Jabatan Text and Icon
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Icon(
                                Iconsax.briefcase,
                                color: AppColors.darkGrey,
                                size: 22,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Jabatan Fungsional',
                                      style: TextStyle(
                                        color: AppColors.darkGrey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    _selectedJabatan != null
                                        ? Text(
                                            _selectedJabatan!,
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

              // Hidden dropdown for validation and function (Jabatan)
              Container(
                height: 0,
                child: Opacity(
                  opacity: 0,
                  child: DropdownButtonFormField<String>(
                    value: _selectedJabatan,
                    items: _jabatanOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedJabatan = newValue;
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

              // 6. Kata Sandi
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: inputDecoration.copyWith(
                  labelText: AppTexts.password,
                  hintText: 'Minimal 6 karakter',
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

              // 7. Konfirmasi Kata Sandi
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
                      _obscureConfirmPassword ? Iconsax.eye_slash : Iconsax.eye,
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
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_agreeToTerms) {
                          _handleRegister();
                        } else {
                          // Tampilkan pesan jika terms belum dicentang
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Anda harus menyetujui syarat dan ketentuan terlebih dahulu'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
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
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        AppTexts.signUp.toUpperCase(),
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
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.darkGrey,
                            fontSize: isSmallScreen ? 11 : 12,
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
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 11 : 12,
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
    );
  }

  // Method untuk menampilkan bottom sheet jabatan fungsional
  void _showJabatanBottomSheet(BuildContext context) {
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
                                Iconsax.briefcase,
                                color: AppColors.primary,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Pilih Jabatan Fungsional',
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

                  // Jabatan list
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _jabatanOptions.length,
                      itemBuilder: (context, index) {
                        final jabatan = _jabatanOptions[index];
                        final isSelected = _selectedJabatan == jabatan;

                        return InkWell(
                          onTap: () {
                            // Update both local and parent state
                            setModalState(() {
                              _selectedJabatan = jabatan;
                            });
                            setState(() {
                              _selectedJabatan = jabatan;
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    jabatan,
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
}
