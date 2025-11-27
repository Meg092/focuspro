import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'ft_poetry_list_logic.dart';

class FtPoetryListView extends GetView<FtPoetryListLogic> {
  const FtPoetryListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Poetry'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.3))),
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
            colors: [Colors.pink.shade50, Colors.pink.shade100],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: controller.poems.length,
                    itemBuilder: (context, index) {
                      final poem = controller.poems[index];
                      final isLocked = controller.isPoemLocked(poem.id);
                      final bestTime = controller.getBestTime(poem.id);
                      
                      return _buildPoetryCard(
                        id: poem.id,
                        title: poem.title,
                        author: '${poem.author}, ${poem.year}',
                        preview: poem.preview,
                        time: bestTime,
                        isLocked: isLocked,
                        onTap: () => controller.onPoetryTap(poem.id),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPoetryCard({
    required int id,
    required String title,
    required String author,
    required String preview,
    required String time,
    required bool isLocked,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: isLocked
              ? LinearGradient(
                  colors: [Colors.grey.shade100, Colors.grey.shade200],
                )
              : const LinearGradient(
                  colors: [Color(0xFFFFF7ED), Color(0xFFFEF3C7)],
                ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isLocked ? Colors.grey.shade300 : const Color(0xFFFBCF33),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isLocked) ...[
                            Icon(Icons.lock, size: 16.sp, color: Colors.grey.shade600),
                            SizedBox(width: 8.w),
                          ],
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: isLocked ? Colors.grey.shade600 : Colors.grey.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        author,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isLocked ? Colors.grey.shade500 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: isLocked
                            ? Colors.grey.shade400
                            : (time == '0.0' ? Colors.grey.shade400 : Colors.pink),
                      ),
                    ),
                    Text(
                      isLocked ? 'Locked' : 'seconds',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isLocked ? Colors.grey.shade400 : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              preview,
              style: TextStyle(
                fontSize: 14.sp,
                fontStyle: FontStyle.italic,
                color: isLocked ? Colors.grey.shade500 : Colors.grey.shade700,
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
