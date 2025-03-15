import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../widgets/login_form_section.dart';
import '../widgets/login_header_section.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  // Method untuk menutup keyboard
  void _unfocusKeyboard(BuildContext context) {
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

    return GestureDetector(
      // Menutup keyboard saat tap di area kosong
      onTap: () => _unfocusKeyboard(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(0), // AppBar kosong, hanya untuk status bar
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: GestureDetector(
              // Nested GestureDetector untuk memastikan scroll view juga menutup keyboard
              onTap: () => _unfocusKeyboard(context),
              child: Container(
                padding: const EdgeInsets.all(AppSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Add some top spacing
                    const SizedBox(height: AppSizes.spaceBtwSections),

                    // Header Section
                    const LoginHeaderSection(),

                    // Form Section
                    const LoginFormSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
