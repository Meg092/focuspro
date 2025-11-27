import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'ft_listening_menu_logic.dart';

class FtListeningMenuView extends GetView<FtListeningMenuLogic> {
  const FtListeningMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Auditory Focus Training'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                border: Border(
                  bottom: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.teal.shade50, Colors.cyan.shade100],
          ),
        ),
        child: SafeArea(
          child: Column(children: [Expanded(child: _buildContent())]),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        children: [
          _buildHeader(),
          SizedBox(height: 32.h),
          _buildMenuCards(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2DD4BF), Color(0xFF0891B2)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(Icons.headphones, color: Colors.white, size: 40.sp),
        ),
        SizedBox(height: 16.h),
        Text(
          'Listening Training',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Choose a training mode to enhance your auditory focus',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildMenuCards() {
    return Column(
      children: [
        _buildMenuCard(
          gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF9333EA)],
          ),
          icon: Icons.repeat,
          title: 'Listen & Repeat',
          subtitle: 'Hear numbers and repeat them in order',
          onTap: controller.onRepeatTap,
        ),
        SizedBox(height: 16.h),
        _buildMenuCard(
          gradient: const LinearGradient(
            colors: [Color(0xFFFB923C), Color(0xFFF59E0B)],
          ),
          icon: Icons.swap_horiz,
          title: 'Listen & Reverse',
          subtitle: 'Hear numbers and reverse the order',
          onTap: controller.onReverseTap,
        ),
        SizedBox(height: 16.h),
        _buildMenuCard(
          gradient: const LinearGradient(
            colors: [Color(0xFF4ADE80), Color(0xFF059669)],
          ),
          icon: Icons.category,
          title: 'Listen & Categorize',
          subtitle: 'Hear words and categorize them',
          onTap: controller.onCategorizeTap,
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required Gradient gradient,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(icon, color: Colors.white, size: 28.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white, size: 28.sp),
          ],
        ),
      ),
    );
  }
}
