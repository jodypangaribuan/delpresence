import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../widgets/student_signup_form.dart';
import '../widgets/staff_signup_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final PageController _formPageController = PageController();
  final PageController _mainPageController = PageController();
  bool _isFormPage = false;

  // Swipe back animation variables
  double _dragStartX = 0.0;
  double _dragDistance = 0.0;
  bool _isDraggingHorizontally = false;

  // Animation controllers
  late AnimationController _swipeAnimationController;
  late Animation<Offset> _swipeAnimation;

  // Pulse animation for swipe-up icon
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Fix for status bar color
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _formPageController.animateToPage(
          _tabController.index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });

    // Initialize swipe animation
    _swipeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _swipeAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.5),
    ).animate(CurvedAnimation(
      parent: _swipeAnimationController,
      curve: Curves.easeInOut,
    ));

    // Initialize pulse animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _formPageController.dispose();
    _mainPageController.dispose();
    _swipeAnimationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _navigateToFormPage() {
    _mainPageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {
      _isFormPage = true;
    });
  }

  void _navigateBackToIntro() {
    _mainPageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {
      _isFormPage = false;
    });
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Background layer for intro screen only
              Positioned.fill(
                child: Image.asset(
                  'assets/images/background/register-background.png',
                  width: screenWidth,
                  height: screenHeight,
                  fit: BoxFit.cover,
                ),
              ),

              // White background for form page (only visible when _isFormPage is true)
              AnimatedOpacity(
                opacity: _isFormPage ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                ),
              ),

              // Main register screen with gesture detector
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
                    child: PageView(
                      controller: _mainPageController,
                      scrollDirection: Axis.vertical,
                      physics: const ClampingScrollPhysics(),
                      onPageChanged: (index) {
                        _unfocusKeyboard();
                        setState(() {
                          _isFormPage = index == 1;
                        });
                        SystemChrome.setSystemUIOverlayStyle(
                          const SystemUiOverlayStyle(
                            statusBarColor: Colors.transparent,
                            statusBarIconBrightness: Brightness.dark,
                          ),
                        );
                      },
                      children: [
                        // First Page - Intro screen
                        _buildIntroPage(context, screenHeight),

                        // Second Page - Form Screen - adding status bar height
                        _buildFormPage(context, isSmallScreen, statusBarHeight),
                      ],
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

  // Intro page with swipe up indicator
  Widget _buildIntroPage(BuildContext context, double screenHeight) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          // Status bar spacer - transparent
          SizedBox(height: MediaQuery.of(context).padding.top),

          // Main content - SVG illustration centered
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SVG illustration
                  Image.asset(
                    'assets/images/background/sign-up.png',
                    height: screenHeight * 0.4,
                    width: MediaQuery.of(context).size.width * 0.9,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: AppSizes.lg),

                  // Title
                  Text(
                    "Bergabung dengan DelPresence",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.sm),

                  // Subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.defaultSpace),
                    child: Text(
                      "Buat akun untuk absensi lebih mudah dan terorganisir",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.black,
                            fontWeight: FontWeight.w300,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom swipe indicator
          Container(
            margin: const EdgeInsets.only(bottom: AppSizes.md),
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Combined animations: slide up/down and pulse
                SlideTransition(
                  position: _swipeAnimation,
                  child: ScaleTransition(
                    scale: _pulseAnimation,
                    child: SvgPicture.asset(
                      'assets/icons/swipe-up.svg',
                      height: 45,
                      width: 45,
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Geser ke atas untuk mendaftar",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Form page with tabs
  Widget _buildFormPage(
      BuildContext context, bool isSmallScreen, double statusBarHeight) {
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          // Custom AppBar with proper status bar height
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: statusBarHeight + AppSizes.sm,
              left: AppSizes.defaultSpace,
              right: AppSizes.defaultSpace,
              bottom: AppSizes.sm,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  "Formulir Pendaftaran",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                ),
                const SizedBox(height: AppSizes.xs),

                // Subtitle
                Text(
                  "Pilih jenis pengguna dan lengkapi informasi Anda",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.darkGrey,
                      ),
                ),
              ],
            ),
          ),

          // Role Selection Tabs
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? AppSizes.md : AppSizes.defaultSpace,
              vertical: AppSizes.md,
            ),
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.cardRadiusLg),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.cardRadiusLg),
              child: Row(
                children: [
                  // Mahasiswa Tab
                  _buildRoleTab(
                    context: context,
                    index: 0,
                    icon: Iconsax.user,
                    label: "Mahasiswa",
                    isSmallScreen: isSmallScreen,
                  ),

                  // Divider
                  Container(
                    width: 1,
                    height: 50,
                    color: AppColors.grey.withOpacity(0.3),
                  ),

                  // Dosen/Staff Tab
                  _buildRoleTab(
                    context: context,
                    index: 1,
                    icon: Iconsax.teacher,
                    label: "Dosen/TA",
                    isSmallScreen: isSmallScreen,
                  ),
                ],
              ),
            ),
          ),

          // Form Content
          Expanded(
            child: Container(
              color: Colors.white,
              child: GestureDetector(
                onTap: _unfocusKeyboard,
                child: PageView(
                  controller: _formPageController,
                  onPageChanged: (index) {
                    _unfocusKeyboard();
                    setState(() {
                      _tabController.animateTo(index);
                    });
                  },
                  children: const [
                    // Student Form
                    StudentSignupForm(),

                    // Staff Form
                    StaffSignupForm(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom Role Tab Widget
  Widget _buildRoleTab({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
    required bool isSmallScreen,
  }) {
    final isSelected = _tabController.index == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          _unfocusKeyboard(); // Menutup keyboard saat tab diubah
          setState(() {
            _tabController.animateTo(index);
            _formPageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.cardRadiusLg),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.darkGrey,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                isSmallScreen ? (index == 0 ? "Mhs" : "Dosen") : label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.darkGrey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: isSmallScreen ? 12 : 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
