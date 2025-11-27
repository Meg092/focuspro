import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'ft_daily_listen_logic.dart';

class FtDailyListenView extends GetView<FtDailyListenLogic> {
  const FtDailyListenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFFF093FB)],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(child: _buildContent()),
              _buildControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 12.h, top: 50.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
      ),
      child: Center(
        child: Text(
          'Daily Listen',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        Positioned(top: 100.h, left: 40.w, child: _buildFloatingCircle(0)),
        Positioned(bottom: 200.h, right: 48.w, child: _buildFloatingCircle(1)),
        Positioned(top: 300.h, left: 180.w, child: _buildFloatingCircle(2)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDateBadge(),
              SizedBox(height: 32.h),
              _buildContentCard(),
              Obx(() {
                return controller.isPlaying.value
                    ? _buildProgressBar()
                    : const SizedBox.shrink();
              }),
              SizedBox(height: 32.h),
              _buildHintText(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingCircle(int index) {
    final sizes = [96.w, 128.w, 80.w];

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 6),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -20 * (0.5 - (value - 0.5).abs())),
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                width: sizes[index],
                height: sizes[index],
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateBadge() {
    final now = DateTime.now();
    final formattedDate = '${_getMonthName(now.month)} ${now.day}, ${now.year}';

    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: Text(
            formattedDate,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  Widget _buildContentCard() {
    return Container(
      width: double.infinity,
      height: 360.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Obx(() {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: controller.blurAmount.value,
                      sigmaY: controller.blurAmount.value,
                      tileMode: TileMode.decal,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 16.w,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.currentSentence.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              height: 1.6,
                            ),
                          ),
                          // if (!controller.isBlurred.value) ...[
                          //   SizedBox(height: 16.h),
                          //   Text(
                          //     controller.currentTranslation.value,
                          //     textAlign: TextAlign.center,
                          //     style: TextStyle(
                          //       fontSize: 18.sp,
                          //       color: Colors.white.withValues(alpha: 0.8),
                          //       height: 1.5,
                          //     ),
                          //   ),
                          // ],
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.headphones,
                  color: Colors.purple.shade400,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Listen First, Then Read',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: controller.progress.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFFF093FB)],
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHintText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        'Press play to listen. Text will become clear after audio finishes.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: Colors.white.withValues(alpha: 0.9),
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 32.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => GestureDetector(
              onTap: controller.isPlaying.value ? null : controller.playAudio,
              child: Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  controller.isPlaying.value
                      ? Icons.volume_up
                      : Icons.play_arrow,
                  color: Colors.purple.shade600,
                  size: 36.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
