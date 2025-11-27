import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../db_ft/database.dart';
import '../../db_ft/db_ft_entity.dart';
import '../../utils/index.dart';

class FtStandardLogic extends GetxController {
  final timer = '0.00'.obs;
  final isRunning = false.obs;
  final showError = false.obs;
  final nextNumber = 1.obs;
  final clickedNumbers = <int>[].obs;
  final gridNumbers = <int>[].obs;

  Timer? _timer;
  double _elapsedSeconds = 0.0;
  final int gridSize = 5;
  final int totalNumbers = 25;

  @override
  void onInit() {
    super.onInit();
    _initializeGame();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _initializeGame() {
    final numbers = List<int>.generate(totalNumbers, (i) => i + 1);
    numbers.shuffle(Random());
    gridNumbers.value = numbers;
    nextNumber.value = 1;
    clickedNumbers.clear();
    _elapsedSeconds = 0.0;
    timer.value = '0.00';
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

  Future<void> onCellTap(int number) async {
    if (!isRunning.value && nextNumber.value == 1) {
      _startTimer();
    }

    if (number == nextNumber.value) {
      clickedNumbers.add(number);
      nextNumber.value++;
      showError.value = false;

      if (nextNumber.value > totalNumbers) {
        _stopTimer();
        await _saveGameRecord();
        _showCompletionDialog();
      }
    } else {
      showError.value = true;
      Future.delayed(const Duration(milliseconds: 800), () {
        showError.value = false;
      });
    }
  }

  Future<void> _saveGameRecord() async {
    try {
      final record = GameRecord(
        gameMode: 'standard',
        timeTaken: _elapsedSeconds,
        score: calculateScore(
          timeTaken: _elapsedSeconds,
          gridSize: totalNumbers,
          isCompleted: true,
        ),
        playTime: DateTime.now(),
        isCompleted: true,
      );

      await FtDatabase.instance.insertGameRecord(record);
    } catch (e) {
      errorToast('Failed to save record: ${e.toString()}');
    }
  }

  void _showCompletionDialog() {
    final score = calculateScore(
      timeTaken: _elapsedSeconds,
      gridSize: totalNumbers,
      isCompleted: true,
    );
    final percentile = calculatePercentile(score, 'standard');

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, size: 64, color: Color(0xFF2563EB)),
              const SizedBox(height: 16),
              const Text(
                'Completed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Text(
                '${formatTime(_elapsedSeconds)} s',
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
              ),
              const SizedBox(height: 8),
              Text(
                'Score: $score pts',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Defeated $percentile% of players globally',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
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
