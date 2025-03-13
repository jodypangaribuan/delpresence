import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_strings.dart';
import '../widgets/student_signup_form.dart';
import '../widgets/staff_signup_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _pageController.animateToPage(
          _tabController.index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
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

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.defaultSpace,
                vertical: AppSizes.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    AppTexts.signUpTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                  ),
                  const SizedBox(height: AppSizes.xs),

                  // Subtitle
                  Text(
                    AppTexts.signUpSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.darkGrey,
                        ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                ],
              ),
            ),

            // Role Selection Tabs - Custom Implementation
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? AppSizes.md : AppSizes.defaultSpace,
                vertical: AppSizes.xs,
              ),
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.background,
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

            const SizedBox(height: AppSizes.md),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: AppSizes.sm),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 300,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
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
                  ],
                ),
              ),
            ),
          ],
        ),
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
          setState(() {
            _tabController.animateTo(index);
            _pageController.animateToPage(
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
