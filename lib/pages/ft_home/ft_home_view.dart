import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'ft_home_logic.dart';

class FtHomeView extends GetView<FtHomeLogic> {
  const FtHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.indigo.shade100],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 24.h,
                  ),
                  child: Column(
                    children: [
                      _buildWelcomeSection(),
                      SizedBox(height: 24.h),
                      _buildTrainingModesGrid(),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 12.h, top: 50.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Center(
            child: Text(
              'Focus Training',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF9333EA)],
        ),
        borderRadius: BorderRadius.circular(24.r),
      ),
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to FocusTrain!',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Choose a training mode to improve your attention and concentration',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingModesGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildModeCard(
                title: 'Standard',
                subtitle: '5x5 Schulte Grid',
                gradient: const LinearGradient(
                  colors: [Color(0xFF60A5FA), Color(0xFF2563EB)],
                ),
                icon: Icons.grid_3x3,
                onTap: controller.onStandardModeTap,
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: _buildModeCard(
                title: 'Poetry',
                subtitle: 'Word Puzzle Game',
                gradient: const LinearGradient(
                  colors: [Color(0xFFF472B6), Color(0xFFE11D48)],
                ),
                icon: Icons.menu_book,
                onTap: controller.onPoetryModeTap,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            Expanded(
              child: _buildModeCard(
                title: 'Kids',
                subtitle: 'Progressive Levels',
                gradient: const LinearGradient(
                  colors: [Color(0xFF4ADE80), Color(0xFF059669)],
                ),
                icon: Icons.child_care,
                onTap: controller.onKidsModeTap,
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: _buildModeCard(
                title: 'Challenge',
                subtitle: 'No Mistakes Allowed',
                gradient: const LinearGradient(
                  colors: [Color(0xFFFB923C), Color(0xFFDC2626)],
                ),
                icon: Icons.emoji_events,
                onTap: controller.onChallengeModeTap,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            Expanded(
              child: _buildModeCard(
                title: 'Crazy',
                subtitle: 'Dynamic Reshuffle',
                gradient: const LinearGradient(
                  colors: [Color(0xFFA78BFA), Color(0xFF7C3AED)],
                ),
                icon: Icons.bolt,
                onTap: controller.onCrazyModeTap,
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: _buildModeCard(
                title: 'Listening',
                subtitle: 'Auditory Training',
                gradient: const LinearGradient(
                  colors: [Color(0xFF2DD4BF), Color(0xFF0891B2)],
                ),
                icon: Icons.headphones,
                onTap: controller.onListeningModeTap,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModeCard({
    required String title,
    required String subtitle,
    required Gradient gradient,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56.w,
              height: 56.h,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(icon, color: Colors.white, size: 28.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
