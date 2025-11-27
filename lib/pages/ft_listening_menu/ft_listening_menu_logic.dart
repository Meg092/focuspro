import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/difficulty_dialog.dart';
import 'widgets/category_dialog.dart';

class FtListeningMenuLogic extends GetxController {
  void onRepeatTap() {
    Get.dialog(
      DifficultyDialog(
        targetRoute: '/ft_listening_training/repeat',
        colors: [Color(0xFF6366F1), Color(0xFF9333EA)],
      ),
    );
  }

  void onReverseTap() {
    Get.dialog(
      DifficultyDialog(
        targetRoute: '/ft_listening_training/reverse',
        colors: [Color(0xFFFB923C), Color(0xFFF59E0B)],
      ),
    );
  }

  void onCategorizeTap() {
    Get.dialog(const CategoryDialog());
  }
}
