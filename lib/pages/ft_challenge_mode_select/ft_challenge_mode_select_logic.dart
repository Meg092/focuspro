import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../db_ft/database.dart';
import '../../db_ft/db_ft_entity.dart';
import '../../utils/index.dart';

class FtChallengeModeSelectLogic extends GetxController {
  final levelProgress = <String, LevelProgress>{}.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadLevelProgress();
  }

  Future<void> _loadLevelProgress() async {
    try {
      isLoading.value = true;
      final allProgress = await FtDatabase.instance.getAllLevelProgress();

      final levels = [
        '3×3',
        '4×4',
        '5×5',
        '6×6',
        '7×7',
        '8×8',
        '9×9',
        'A-Z',
        'a-z',
      ];
      for (var levelId in levels) {
        final progress = allProgress.firstWhereOrNull(
          (p) => p.levelId == levelId,
        );
        if (progress != null) {
          levelProgress[levelId] = progress;
        }
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorToast('Failed to load progress: ${e.toString()}');
    }
  }

  void onLevelTap(String level) {
    Get.toNamed(
      '/ft_number_game',
      arguments: {
        'level': level,
        'mode': 'challenge',
        'modeTitle': 'Challenge',
        'themeColors': [Colors.orange.shade50, Colors.red.shade100],
        'primaryColor': const Color(0xFFF59E0B),
        'rulesText': 'One mistake and game over! Stay focused',
      },
    )?.then((_) => _loadLevelProgress());
  }

  String getBestTime(String level) {
    final progress = levelProgress[level];
    if (progress?.bestTime == null) return '0.00';
    return formatTime(progress!.bestTime!);
  }
}
