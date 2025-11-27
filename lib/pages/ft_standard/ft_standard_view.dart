import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'ft_standard_logic.dart';

class FtStandardView extends GetView<FtStandardLogic> {
  const FtStandardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Standard'),
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
            colors: [Colors.blue.shade50, Colors.indigo.shade100],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTimer(),
              Expanded(child: Center(child: _buildGrid())),
              _buildRestartButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimer() {
    return Obx(
      () => Container(
        margin: EdgeInsets.only(top: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              controller.timer.value,
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2563EB),
              ),
            ),
            SizedBox(width: 6.w),
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Text(
                's',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 8.w,
                crossAxisSpacing: 8.w,
              ),
              itemCount: 25,
              itemBuilder: (context, index) {
                final numbers = controller.gridNumbers;
                final number = numbers[index];

                return Obx(() {
                  final isClicked = controller.clickedNumbers.contains(number);

                  return GestureDetector(
                    onTap: () => controller.onCellTap(number),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isClicked
                            ? const Color(0xFF2563EB)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          number.toString(),
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: isClicked
                                ? Colors.white
                                : Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
            Obx(
              () => controller.showError.value
                  ? Center(
                      child: Container(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              controller.nextNumber.value.toString(),
                              style: TextStyle(
                                fontSize: 200.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withValues(alpha: 0.3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestartButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: controller.restart,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2563EB),
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
              Icon(Icons.refresh, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Restart',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
