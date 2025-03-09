import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:delcommerce/core/utils/constants/text_strings.dart';
import 'package:delcommerce/core/utils/theme/theme.dart';
import 'package:delcommerce/features/auth/presentation/logic/on_boarding/on_boarding_cubit.dart';
import 'package:delcommerce/features/auth/presentation/views/on_boarding/on_boarding_view.dart';

class DelStore extends StatelessWidget {
  const DelStore({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: DelTexts.appName,
      themeMode: ThemeMode.system,
      theme: DelAppTheme.lightTheme,
      darkTheme: DelAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => OnBoardingCubit(),
        child: const OnBoardingView(),
      ),
    );
  }
}
