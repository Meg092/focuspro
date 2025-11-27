import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CategoryDialog extends StatelessWidget {
  const CategoryDialog({super.key});

  static final categories = [
    {
      'title': 'Vegetables vs Fruits',
      'gradient': [Color(0xFF34D399), Color(0xFF10B981)],
    },
    {
      'title': 'Animals vs Plants',
      'gradient': [Color(0xFF60A5FA), Color(0xFF3B82F6)],
    },
    {
      'title': 'Vegetables vs Animals',
      'gradient': [Color(0xFFFBBF24), Color(0xFFF59E0B)],
    },
    {
      'title': 'Fruits vs Animals',
      'gradient': [Color(0xFFF87171), Color(0xFFEF4444)],
    },
    {
      'title': 'Numbers vs Letters',
      'gradient': [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
    },
    {
      'title': 'Birds vs Insects',
      'gradient': [Color(0xFF2DD4BF), Color(0xFF14B8A6)],
    },
    {
      'title': 'Fish vs Vegetables',
      'gradient': [Color(0xFFFB923C), Color(0xFFF97316)],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Container(
        constraints: BoxConstraints(maxHeight: 600.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Flexible(child: _buildList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4ADE80), Color(0xFF059669)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.category, color: Colors.white, size: 28.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Choose Category',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white, size: 24.sp),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.all(16.w),
      itemCount: categories.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildOption(
          category['title'] as String,
          category['gradient'] as List<Color>,
        );
      },
    );
  }

  Widget _buildOption(String title, List<Color> gradient) {
    return InkWell(
      onTap: () {
        Get.back();
        Get.toNamed(
          '/ft_listening_training/categorize',
          arguments: {'categoryType': title},
        );
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Icon(Icons.chevron_right, color: Colors.white, size: 24.sp),
          ],
        ),
      ),
    );
  }
}
