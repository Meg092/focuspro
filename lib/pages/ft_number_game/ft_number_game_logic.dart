import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../db_ft/database.dart';
import '../../db_ft/db_ft_entity.dart';
import '../../utils/index.dart';

class FtNumberGameLogic extends GetxController {
  final timer = '0.00'.obs;
  final nextTarget = ''.obs;
  final showError = false.obs;
  final clickedItems = <String>[].obs;
  final gridItems = <String>[].obs;
  final isRunning = false.obs;

  Timer? _timer;
  double _elapsedSeconds = 0.0;
  int _errorCount = 0;
  double? _reactionTime;
  final List<double> _clickTimes = [];

  late String level;
  late String mode;
  late String modeTitle;
  late List<Color> themeColors;
  late Color primaryColor;
  late String rulesText;
  late int gridSize;
  late List<String> allItems;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    level = args['level'] as String;
    mode = args['mode'] as String? ?? 'kids';
    modeTitle = args['modeTitle'] as String? ?? mode.capitalizeFirst ?? 'Game';

    themeColors =
        args['themeColors'] as List<Color>? ??
        [Colors.green.shade50, Colors.teal.shade100];
    primaryColor = args['primaryColor'] as Color? ?? Colors.green;
    rulesText =
        args['rulesText'] as String? ??
        'Click numbers from small to large in order';

    _initializeGame();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _initializeGame() {
    gridSize = getLevelGridSize(level);

    if (level == 'A-Z') {
      allItems = List.generate(26, (i) => String.fromCharCode(65 + i));
    } else if (level == 'a-z') {
      allItems = List.generate(26, (i) => String.fromCharCode(97 + i));
    } else {
      final size = gridSize * gridSize;
      allItems = List.generate(size, (i) => (i + 1).toString());
    }

    final shuffled = List<String>.from(allItems);
    shuffled.shuffle(Random());
    gridItems.value = shuffled;

    nextTarget.value = allItems[0];
    clickedItems.clear();
    _elapsedSeconds = 0.0;
    timer.value = '0.00';
    _errorCount = 0;
    _reactionTime = null;
    _clickTimes.clear();

    _startTimer();
  }

  void _startTimer() {
    if (isRunning.value) return;

    isRunning.value = true;
    _timer = Timer.periodic(const Duration(milliseconds: 10), (t) {
      _elapsedSeconds += 0.01;
      timer.value = formatTime(_elapsedSeconds);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    isRunning.value = false;
  }

  Future<void> onCellTap(String item) async {
    final currentIndex = clickedItems.length;
    final expectedItem = allItems[currentIndex];

    if (item == expectedItem) {
      clickedItems.add(item);
      showError.value = false;

      _clickTimes.add(_elapsedSeconds);

      _reactionTime ??= _elapsedSeconds;

      if (mode == 'crazy' && currentIndex < allItems.length - 1) {
        _reshuffleRemaining();
      }

      if (currentIndex + 1 < allItems.length) {
        nextTarget.value = allItems[currentIndex + 1];
      }

      if (clickedItems.length >= allItems.length) {
        _stopTimer();
        await _saveGameRecord(isCompleted: true);
        _showCompletionDialog();
      }
    } else {
      _errorCount++;

      if (mode == 'challenge') {
        _stopTimer();
        await _saveGameRecord(isCompleted: false);
        _showFailureDialog();
      } else {
        showError.value = true;
        Future.delayed(const Duration(milliseconds: 800), () {
          showError.value = false;
        });
      }
    }
  }

  void _reshuffleRemaining() {
    final newGrid = List<String>.from(gridItems);
    newGrid.shuffle(Random());
    gridItems.value = newGrid;
  }

  Future<void> _saveGameRecord({required bool isCompleted}) async {
    try {
      final gameModeKey = mode == 'kids'
          ? 'kids_$level'
          : mode == 'challenge'
          ? 'challenge_$level'
          : mode == 'crazy'
          ? 'crazy_$level'
          : 'poetry_$level';

      double? clickSpeed;
      if (_clickTimes.length > 1) {
        final intervals = <double>[];
        for (int i = 1; i < _clickTimes.length; i++) {
          intervals.add(_clickTimes[i] - _clickTimes[i - 1]);
        }
        clickSpeed = intervals.reduce((a, b) => a + b) / intervals.length;
      }

      final record = GameRecord(
        gameMode: gameModeKey,
        timeTaken: _elapsedSeconds,
        score: calculateScore(
          timeTaken: _elapsedSeconds,
          gridSize: allItems.length,
          isCompleted: isCompleted,
        ),
        playTime: DateTime.now(),
        isCompleted: isCompleted,
        errorCount: _errorCount,
        reactionTime: _reactionTime,
        clickSpeed: clickSpeed,
      );

      await FtDatabase.instance.insertGameRecord(record);

      if (isCompleted) {
        await _updateLevelProgress();
      }
    } catch (e) {
      errorToast('Failed to save record: ${e.toString()}');
    }
  }

  Future<void> _updateLevelProgress() async {
    try {
      final progress = await FtDatabase.instance.getLevelProgress(level);

      if (progress != null) {
        if (progress.bestTime == null || _elapsedSeconds < progress.bestTime!) {
          progress.bestTime = _elapsedSeconds;
        }
        progress.lastPlayed = DateTime.now();
        await FtDatabase.instance.updateLevelProgress(progress);
      }

      final nextLevelId = getNextLevel(level);
      if (nextLevelId != null) {
        final nextProgress = await FtDatabase.instance.getLevelProgress(
          nextLevelId,
        );
        if (nextProgress != null && !nextProgress.isUnlocked) {
          nextProgress.isUnlocked = true;
          await FtDatabase.instance.updateLevelProgress(nextProgress);
          infoToast('Level $nextLevelId unlocked!');
        }
      }
    } catch (e) {
      errorToast('Failed to update progress: ${e.toString()}');
    }
  }

  void _showCompletionDialog() {
    final score = calculateScore(
      timeTaken: _elapsedSeconds,
      gridSize: allItems.length,
      isCompleted: true,
    );
    final percentile = calculatePercentile(score, '${mode}_$level');

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.emoji_events, size: 64, color: primaryColor),
              const SizedBox(height: 16),
              const Text(
                'Completed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Text(
                '${formatTime(_elapsedSeconds)} s',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text('Score: $score pts', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text(
                'Defeated $percentile% of players globally',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              _buildStatistics(),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                        restart();
                      },
                      child: const Text('Retry'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(closeOverlays: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                      ),
                      child: const Text('OK'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildStatistics() {
    final clickSpeed = _clickTimes.length > 1
        ? (_clickTimes.last - _clickTimes.first) / (_clickTimes.length - 1)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildStatRow('Errors', _errorCount.toString()),
          const SizedBox(height: 8),
          _buildStatRow(
            'Reaction Time',
            _reactionTime != null ? '${formatTime(_reactionTime!)} s' : 'N/A',
          ),
          const SizedBox(height: 8),
          _buildStatRow(
            'Click Speed',
            clickSpeed > 0 ? '${formatTime(clickSpeed)} s/click' : 'N/A',
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  void _showFailureDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cancel, size: 64, color: Color(0xFFEF4444)),
              const SizedBox(height: 16),
              const Text(
                'Challenge Failed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Text(
                'Correct: ${clickedItems.length}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Time: ${formatTime(_elapsedSeconds)} s',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                        restart();
                      },
                      child: const Text('Retry'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(closeOverlays: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                      ),
                      child: const Text('OK'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void restart() {
    _stopTimer();
    _initializeGame();
  }
}
