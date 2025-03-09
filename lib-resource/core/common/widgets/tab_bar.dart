import 'package:flutter/material.dart';
import 'package:delcommerce/core/common/view_models/tab_bar_view_model.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/device/device_utility.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomTabBar({super.key, required this.tabBarModel});
  final TabBarModel tabBarModel;
  @override
  Widget build(BuildContext context) {
    final dark = DelHelperFunctions.isDarkMode(context);
    return Material(
        color: dark ? TColors.black : TColors.white,
        child: TabBar(
          isScrollable: true,
          indicatorColor: tabBarModel.indicatorColor,
          unselectedLabelColor: tabBarModel.unselectedLabelColor,
          labelColor: tabBarModel.labelColor,
          tabs: tabBarModel.tabs,
        ));
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}
