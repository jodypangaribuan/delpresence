import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:async';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_strings.dart';
import 'terms_and_privacy_agreement.dart';

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

  // Dropdown state
  bool _isProdiDropdownOpen = false;
  bool _isAngkatanDropdownOpen = false;

  // Focus nodes for tracking dropdown state
  final _prodiFocusNode = FocusNode();
  final _angkatanFocusNode = FocusNode();

  // Dropdown options
  String? _selectedProdi;
  String? _selectedAngkatan;

  // Program studi options
  final List<String> _prodiOptions = [
    'S1 Informatika',
    'S1 Sistem Informasi',
    'S1 Teknik Elektro',
    'S1 Manajemen Rekayasa',
    'D4 TRPL',
    'D3 Teknologi Informasi',
    'D3 Teknologi Komputer',
  ];

  // Angkatan options
  final List<String> _angkatanOptions = [
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
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

    // Show notification popup after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNotificationPopup();
    });
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
    );

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                          horizontal: isSmallScreen ? AppSizes.sm : AppSizes.md,
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
                        labelText:
                            isSmallScreen ? 'Nama Tengah *' : 'Nama Tengah *',
                        hintText: 'Tengah',
                        helperText: null,
                        suffixIcon: Icon(
                          Icons.star,
                          color: Colors.red,
                          size: 10,
                        ),
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

              // 4. NIM
              TextFormField(
                controller: _nimController,
                keyboardType:
                    TextInputType.text, // Changed to text to allow alphanumeric
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
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Icon(
                                Iconsax.calendar,
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
              const SizedBox(height: AppSizes.spaceBtwSections),

              // Tombol Daftar
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _agreeToTerms
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            // Perform registration logic
                            // You can add registration logic here
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? AppSizes.md : AppSizes.lg,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.buttonRadius),
                    ),
                    elevation:
                        0, // No elevation since we're using shadow on container
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                  child: Text(
                    AppTexts.signUp.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: isSmallScreen ? 13 : 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spaceBtwItems),

              // Sudah memiliki akun
              Row(
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
              const SizedBox(height: AppSizes.spaceBtwItems),
            ],
          ),
        ),
      ),
    );
  }

  // Method untuk menampilkan bottom sheet program studi
  void _showProdiBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      'Pilih Program Studi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: _prodiOptions.length,
                  itemBuilder: (context, index) {
                    final prodi = _prodiOptions[index];
                    return ListTile(
                      leading: Icon(
                        Iconsax.book_1,
                        color: AppColors.primary.withOpacity(0.7),
                      ),
                      title: Text(prodi),
                      onTap: () {
                        setState(() {
                          _selectedProdi = prodi;
                        });
                        Navigator.pop(context);
                      },
                      trailing: _selectedProdi == prodi
                          ? Icon(Icons.check, color: AppColors.primary)
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Method untuk menampilkan bottom sheet angkatan
  void _showAngkatanBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      'Pilih Angkatan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: _angkatanOptions.length,
                  itemBuilder: (context, index) {
                    final angkatan = _angkatanOptions[index];
                    return ListTile(
                      leading: Icon(
                        Iconsax.calendar_1,
                        color: AppColors.primary.withOpacity(0.7),
                      ),
                      title: Text(angkatan),
                      onTap: () {
                        setState(() {
                          _selectedAngkatan = angkatan;
                        });
                        Navigator.pop(context);
                      },
                      trailing: _selectedAngkatan == angkatan
                          ? Icon(Icons.check, color: AppColors.primary)
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
