import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../db_ft/database.dart';
import '../../db_ft/db_ft_entity.dart';
import '../../utils/index.dart';

class FtKidsModeSelectLogic extends GetxController {
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
      
      final kidsLevels = ['3×3', '4×4', '5×5', '6×6', '7×7', '8×8', '9×9', 'A-Z', 'a-z'];
      for (var progress in allProgress) {
        if (kidsLevels.contains(progress.levelId)) {
          levelProgress[progress.levelId] = progress;
        }
      }
      
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorToast('Failed to load progress: ${e.toString()}');
    }
  }

  void onLevelTap(String level) {
    final progress = levelProgress[level];
    if (progress == null || !progress.isUnlocked) {
      infoToast('Complete previous level to unlock');
      return;
    }
    
    Get.toNamed(
      '/ft_number_game',
      arguments: {
        'level': level,
        'mode': 'kids',
        'modeTitle': 'Kids',
        'themeColors': [const Color(0xFFECFDF5), const Color(0xFF99F6E4)],
        'primaryColor': const Color(0xFF22C55E),
        'rulesText': 'Click numbers from small to large in order',
      },
    )?.then((_) => _loadLevelProgress());
  }

  String getBestTime(String level) {
    final progress = levelProgress[level];
    if (progress?.bestTime == null) return '0.00';
    return formatTime(progress!.bestTime!);
  }

  bool isLevelLocked(String level) {
    final progress = levelProgress[level];
    return progress == null || !progress.isUnlocked;
  }
}
