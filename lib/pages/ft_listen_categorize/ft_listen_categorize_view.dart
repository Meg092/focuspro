import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'ft_listen_categorize_logic.dart';

class FtListenCategorizeView extends GetView<FtListenCategorizeLogic> {
  const FtListenCategorizeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(controller.categoryType),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
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
            colors: [Colors.green.shade50, Colors.teal.shade100],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildInstructionsCard(),
                _buildAudioIndicator(),
                _buildPlayButton(),
                SizedBox(height: 8.h),
                _buildCategoryButtons(),
                _buildTipsAndControls(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionsCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4ADE80), Color(0xFF059669)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('🎯 ', style: TextStyle(fontSize: 14.sp)),
              Text(
                'Target',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'Training attention span, focus concentration, attention allocation and reaction sensitivity.',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text('📋 ', style: TextStyle(fontSize: 14.sp)),
              Text(
                'Method',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'After hearing each word, judge the category and click the correct option or do the action.',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioIndicator() {
    return SizedBox(
      height: 180.h,
      child: Center(
        child: Obx(() {
          if (controller.showFeedback.value) {
            return Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.currentWord.value,
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Icon(
                    controller.isCorrectAnswer.value
                        ? Icons.check_circle
                        : Icons.cancel,
                    size: 48.sp,
                    color: controller.isCorrectAnswer.value
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                  ),
                ],
              ),
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 8.w,
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  height: controller.waveHeights[index],
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                );
              }),
            );
          }
        }),
      ),
    );
  }

  Widget _buildPlayButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: SizedBox(
        height: 80.h,
        child: Center(
          child: Obx(() {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4ADE80), Color(0xFF059669)],
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: controller.isPlaying.value
                    ? null
                    : controller.onPlayTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      controller.isPlaying.value
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 24.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      controller.isPlaying.value ? 'Playing' : 'Start Playing',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCategoryButtons() {
    final categoryInfo = controller.categoryInfo;
    final category1 = categoryInfo['category1'];
    final category2 = categoryInfo['category2'];

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
      child: Row(
        children: [
          Expanded(
            child: _buildCategoryButton(
              category1['name'],
              category1['emoji'],
              controller.onCategory1Tap,
              _getCategoryColors(category1['key']),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildCategoryButton(
              category2['name'],
              category2['emoji'],
              controller.onCategory2Tap,
              _getCategoryColors(category2['key']),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(
    String name,
    String emoji,
    VoidCallback onTap,
    List<Color> colors,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 240.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: TextStyle(fontSize: 48.sp)),
            SizedBox(height: 8.h),
            Text(
              name,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _getCategoryColors(String categoryKey) {
    final colorMap = {
      'vegetables': [const Color(0xFFF472B6), const Color(0xFFF97316)],
      'fruits': [const Color(0xFF4ADE80), const Color(0xFF059669)],
      'animals': [const Color(0xFF60A5FA), const Color(0xFF2563EB)],
      'plants': [const Color(0xFF34D399), const Color(0xFF059669)],
      'numbers': [const Color(0xFFFBBF24), const Color(0xFFD97706)],
      'letters': [const Color(0xFFA78BFA), const Color(0xFF7C3AED)],
      'birds': [const Color(0xFF06B6D4), const Color(0xFF0891B2)],
      'insects': [const Color(0xFFFF6B6B), const Color(0xFFEE5A52)],
      'fish': [const Color(0xFF3B82F6), const Color(0xFF1E40AF)],
    };

    return colorMap[categoryKey] ??
        [const Color(0xFF6B7280), const Color(0xFF374151)];
  }

  Widget _buildTipsAndControls() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        children: [
          Text(
            '💡 Tip: Kids can just do actions, \'Vegetables\' use right hand, \'Fruits\' use left hand. Parents can help record or input results',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
          ),
          SizedBox(height: 12.h),
          _buildToggle(
            'Score Broadcast:',
            controller.scoreBroadcast,
            controller.toggleScoreBroadcast,
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(String label, RxBool value, VoidCallback onTap) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade700),
        ),
        SizedBox(width: 8.w),
        Obx(
          () => GestureDetector(
            onTap: onTap,
            child: Container(
              width: 40.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: value.value ? Colors.green : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.all(2.w),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: value.value
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
