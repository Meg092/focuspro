import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'ft_listen_reverse_logic.dart';

class FtListenReverseView extends GetView<FtListenReverseLogic> {
  const FtListenReverseView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          controller.onPageExit();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Listen & Reverse: 3 Digits'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              controller.onPageExit();
              Get.back();
            },
          ),
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
            colors: [Colors.orange.shade50, Colors.yellow.shade100],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildInstructionsCard(),
                Obx(() {
                  if (controller.hasPlayedOnce.value &&
                      !controller.isPlaying.value) {
                    return Column(
                      children: [
                        SizedBox(height: 12.h),
                        _buildInputDisplay(),
                        SizedBox(height: 16.h),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      SizedBox(height: 12.h),
                      _buildAudioIndicator(),
                      SizedBox(height: 16.h),
                    ],
                  );
                }),
                _buildNumberKeypad(),
                SizedBox(height: 16.h),
                _buildPlayButton(),
                _buildTipsAndControls(),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildInstructionsCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFB923C), Color(0xFFF59E0B)],
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
          Text(
            '🎯 Target: Training focus concentration, reaction speed and short-term memory.',
            style: TextStyle(fontSize: 12.sp, color: Colors.white),
          ),
          SizedBox(height: 6.h),
          Text(
            '📋 Method: After hearing 3 digits, reverse the order and input the result.',
            style: TextStyle(fontSize: 12.sp, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioIndicator() {
    return SizedBox(
      height: 64.h,
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 8.w,
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              height: controller.waveHeights[index],
              decoration: BoxDecoration(
                color: const Color(0xFFFB923C),
                borderRadius: BorderRadius.circular(4.r),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildInputDisplay() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 32.w),
      padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFFB923C), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Your Input:',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
          Obx(() {
            final input = controller.userInput;
            String displayText;
            if (input.isEmpty) {
              displayText = '';
            } else {
              displayText = input.join();
            }
            return Text(
              displayText,
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
                letterSpacing: 2,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNumberKeypad() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 64.w),
      child: Column(
        children: [
          Row(
            children: [
              _buildNumberButton('1'),
              SizedBox(width: 12.w),
              _buildNumberButton('2'),
              SizedBox(width: 12.w),
              _buildNumberButton('3'),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildNumberButton('4'),
              SizedBox(width: 12.w),
              _buildNumberButton('5'),
              SizedBox(width: 12.w),
              _buildNumberButton('6'),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildNumberButton('7'),
              SizedBox(width: 12.w),
              _buildNumberButton('8'),
              SizedBox(width: 12.w),
              _buildNumberButton('9'),
            ],
          ),
          SizedBox(height: 12.h),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildNumberButton('0'),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 2,
                  child: Obx(
                    () => GestureDetector(
                      onTap: controller.isPlaying.value
                          ? null
                          : controller.onDeleteTap,
                      child: Opacity(
                        opacity: controller.isPlaying.value ? 0.4 : 1.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFB923C), Color(0xFFF59E0B)],
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Icon(
                            Icons.backspace,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Obx(
          () => GestureDetector(
            onTap: controller.isPlaying.value
                ? null
                : () => controller.onNumberTap(int.parse(number)),
            child: Opacity(
              opacity: controller.isPlaying.value ? 0.4 : 1.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFB923C), Color(0xFFF59E0B)],
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
                child: Center(
                  child: Text(
                    number,
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: SizedBox(
        width: double.infinity,
        child: Obx(
          () => ElevatedButton(
            onPressed: controller.isPlaying.value ? null : controller.onPlayTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFB923C),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              elevation: 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
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
        ),
      ),
    );
  }

  Widget _buildTipsAndControls() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        children: [
          Text(
            '💡 Tip: Listen carefully and reverse the order (e.g. 1-2-3 → 3-2-1)',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Score Broadcast:',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
              ),
              SizedBox(width: 8.w),
              Obx(
                () => GestureDetector(
                  onTap: controller.toggleScoreBroadcast,
                  child: Container(
                    width: 48.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: controller.scoreBroadcast.value
                          ? const Color(0xFFFB923C)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.all(2.w),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      alignment: controller.scoreBroadcast.value
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 20.w,
                        height: 20.w,
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
          ),
        ],
      ),
    );
  }
}
