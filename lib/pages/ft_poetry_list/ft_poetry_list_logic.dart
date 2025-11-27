import 'package:get/get.dart';
import '../../models/poem.dart';
import '../../services/poetry_service.dart';
import '../../db_ft/database.dart';
import '../../db_ft/db_ft_entity.dart';
import '../../utils/index.dart';

class FtPoetryListLogic extends GetxController {
  final poems = <Poem>[].obs;
  final levelProgress = <String, LevelProgress>{}.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      isLoading.value = true;
      
      poems.value = PoetryService.getAllPoems();
      
      final allProgress = await FtDatabase.instance.getAllLevelProgress();
      for (var progress in allProgress) {
        if (progress.levelId.startsWith('poetry_')) {
          levelProgress[progress.levelId] = progress;
        }
      }
      
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorToast('Failed to load poetry data: ${e.toString()}');
    }
  }

  void onPoetryTap(int poemId) {
    final progressKey = 'poetry_$poemId';
    final progress = levelProgress[progressKey];
    
    if (progress == null || !progress.isUnlocked) {
      infoToast('Complete previous poem to unlock');
      return;
    }

    Get.toNamed(
      '/ft_poetry_mode/game',
      arguments: {'poemId': poemId},
    )?.then((_) => _loadData());
  }

  String getBestTime(int poemId) {
    final progressKey = 'poetry_$poemId';
    final progress = levelProgress[progressKey];
    if (progress?.bestTime == null) return '0.00';
    return formatTime(progress!.bestTime!);
  }

  bool isPoemLocked(int poemId) {
    final progressKey = 'poetry_$poemId';
    final progress = levelProgress[progressKey];
    return progress == null || !progress.isUnlocked;
  }
}
