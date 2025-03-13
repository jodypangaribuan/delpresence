import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_strings.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set status bar color to match app theme
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          title: Text(
            'Home',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Iconsax.logout, color: Colors.black),
              onPressed: () {
                // Trigger logout
                context.read<AuthBloc>().add(LogoutEvent());
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.all(AppSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to DelPresence',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    'Your attendance management system',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.darkGrey,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
