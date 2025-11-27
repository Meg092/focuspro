import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/poem.dart';
import '../../services/poetry_service.dart';
import '../../db_ft/database.dart';
import '../../db_ft/db_ft_entity.dart';
import '../../utils/index.dart';

class FtPoetryGameLogic extends GetxController {
  final timer = '0.00'.obs;
  final nextWord = ''.obs;
  final showError = false.obs;
  final clickedIndices = <int>{}.obs;
  final gridWords = <String>[].obs;
  final isRunning = false.obs;

  Timer? _timer;
  double _elapsedSeconds = 0.0;
  
  late Poem currentPoem;
  late List<String> allWords;
  int _currentWordIndex = 0;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    final poemId = args['poemId'] as int;
    
    final poem = PoetryService.getPoemById(poemId);
    if (poem == null) {
      errorToast('Poem not found');
      Get.back();
      return;
    }
    
    currentPoem = poem;
    _initializeGame();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _initializeGame() {
    allWords = currentPoem.words;
    
    final shuffled = List<String>.from(allWords);
    shuffled.shuffle(Random());
    gridWords.value = shuffled;
    
    _currentWordIndex = 0;
    nextWord.value = allWords.isNotEmpty ? allWords[0] : '';
    clickedIndices.clear();
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

  Future<void> onWordTap(int index) async {
    final word = gridWords[index];
    
    if (!isRunning.value && _currentWordIndex == 0) {
      _startTimer();
    }

    if (word == allWords[_currentWordIndex]) {
      clickedIndices.add(index);
      _currentWordIndex++;
      showError.value = false;

      if (_currentWordIndex < allWords.length) {
        nextWord.value = allWords[_currentWordIndex];
      }

      if (_currentWordIndex >= allWords.length) {
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
        gameMode: 'poetry_${currentPoem.id}',
        timeTaken: _elapsedSeconds,
        score: calculateScore(
          timeTaken: _elapsedSeconds,
          gridSize: allWords.length,
          isCompleted: true,
        ),
        playTime: DateTime.now(),
        isCompleted: true,
      );

      await FtDatabase.instance.insertGameRecord(record);

      await _updatePoemProgress();
    } catch (e) {
      errorToast('Failed to save record: ${e.toString()}');
    }
  }

  Future<void> _updatePoemProgress() async {
    try {
      final progressKey = 'poetry_${currentPoem.id}';
      final progress = await FtDatabase.instance.getLevelProgress(progressKey);
      
      if (progress != null) {
        if (progress.bestTime == null || _elapsedSeconds < progress.bestTime!) {
          progress.bestTime = _elapsedSeconds;
        }
        progress.lastPlayed = DateTime.now();
        await FtDatabase.instance.updateLevelProgress(progress);
      }

      if (currentPoem.id < 20) {
        final nextKey = 'poetry_${currentPoem.id + 1}';
        final nextProgress = await FtDatabase.instance.getLevelProgress(nextKey);
        if (nextProgress != null && !nextProgress.isUnlocked) {
          nextProgress.isUnlocked = true;
          await FtDatabase.instance.updateLevelProgress(nextProgress);
          infoToast('Next poem unlocked!');
        }
      }
    } catch (e) {
      errorToast('Failed to update progress: ${e.toString()}');
    }
  }

  void _showCompletionDialog() {
    final score = calculateScore(
      timeTaken: _elapsedSeconds,
      gridSize: allWords.length,
      isCompleted: true,
    );
    final percentile = calculatePercentile(score, 'poetry');

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, size: 64, color: Color(0xFFF472B6)),
              const SizedBox(height: 16),
              const Text(
                'Poem Completed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Text(
                '${formatTime(_elapsedSeconds)} s',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF472B6),
                ),
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF472B6),
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

  void start() {
    if (!isRunning.value) {
      _startTimer();
    }
  }

  void restart() {
    _stopTimer();
    _initializeGame();
  }

  void showAnnotation() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentPoem.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                currentPoem.author,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              const Text(
                'This is a public domain poem, free to use for educational purposes.',
                style: TextStyle(fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
