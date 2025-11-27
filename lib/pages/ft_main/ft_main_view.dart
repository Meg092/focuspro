import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_train/main.dart';
import 'package:get/get.dart';
import 'ft_main_logic.dart';
import '../ft_home/ft_home_view.dart';
import '../ft_daily_listen/ft_daily_listen_view.dart';
import '../ft_settings/ft_settings_view.dart';

class FtMainView extends GetView<FtMainLogic> {
  const FtMainView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const FtHomeView(),
      const FtDailyListenView(),
      const FtSettingsView(),
    ];

    return Scaffold(
      body: Obx(() => pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(() => _buildBottomNavBar()),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: Row(
            children: [
              Expanded(
                child: _buildNavItem(
                  icon: Icons.home,
                  label: 'Home',
                  index: 0,
                  currentIndex: controller.currentIndex.value,
                  onTap: () => controller.changeTab(0),
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  icon: Icons.headphones,
                  label: 'Daily Listen',
                  index: 1,
                  currentIndex: controller.currentIndex.value,
                  onTap: () => controller.changeTab(1),
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  icon: Icons.settings,
                  label: 'Settings',
                  index: 2,
                  currentIndex: controller.currentIndex.value,
                  onTap: () => controller.changeTab(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required int currentIndex,
    required VoidCallback onTap,
  }) {
    final isActive = index == currentIndex;
    final color = isActive ? primaryColor : Colors.grey.shade400;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.transparent),
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28.sp, color: color),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: color,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
