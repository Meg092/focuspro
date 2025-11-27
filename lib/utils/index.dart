import 'package:flutter/material.dart';
import 'package:get/get.dart';

void successToast(String msg) {
  Get.snackbar(
    '',
    msg,
    titleText: const SizedBox.shrink(),
    backgroundColor: const Color(0xFF10B981),
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(16),
    borderRadius: 12,
    duration: const Duration(seconds: 2),
    icon: const Icon(Icons.check_circle, color: Colors.white),
  );
}

void errorToast(String msg) {
  Get.snackbar(
    '',
    msg,
    titleText: const SizedBox.shrink(),
    backgroundColor: const Color(0xFFEF4444),
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(16),
    borderRadius: 12,
    duration: const Duration(seconds: 2),
    icon: const Icon(Icons.error, color: Colors.white),
  );
}

void infoToast(String msg) {
  Get.snackbar(
    '',
    msg,
    titleText: const SizedBox.shrink(),
    backgroundColor: const Color(0xFF3B82F6),
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(16),
    borderRadius: 12,
    duration: const Duration(seconds: 2),
    icon: const Icon(Icons.info, color: Colors.white),
  );
}

String getDateString(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

String extractDateFromDateTime(String dateTimeString) {
  if (dateTimeString.contains(' ')) {
    return dateTimeString.split(' ')[0];
  }
  return dateTimeString.substring(0, 10);
}

String formatTime(double seconds) {
  return seconds.toStringAsFixed(2);
}

int calculateScore({
  required double timeTaken,
  required int gridSize,
  required bool isCompleted,
}) {
  if (!isCompleted) return 0;

  final perfectTime = gridSize * 0.5;
  final baseScore = (perfectTime / timeTaken * 100).clamp(0, 100);

  final difficultyMultiplier = (gridSize / 9);

  final finalScore = (baseScore * difficultyMultiplier).round();
  return finalScore;
}

int calculatePercentile(int score, String gameMode) {
  if (score >= 500) return 95;
  if (score >= 400) return 90;
  if (score >= 300) return 80;
  if (score >= 200) return 70;
  if (score >= 100) return 50;
  if (score >= 50) return 30;
  return 10;
}

int getLevelGridSize(String level) {
  switch (level) {
    case '3×3':
      return 3;
    case '4×4':
      return 4;
    case '5×5':
      return 5;
    case '6×6':
      return 6;
    case '7×7':
      return 7;
    case '8×8':
      return 8;
    case '9×9':
      return 9;
    case 'A-Z':
    case 'a-z':
      return 6;
    default:
      return 5;
  }
}

String? getNextLevel(String currentLevel) {
  const levels = [
    '3×3',
    '4×4',
    '5×5',
    '6×6',
    '7×7',
    '8×8',
    '9×9',
    'A-Z',
    'a-z'
  ];

  final currentIndex = levels.indexOf(currentLevel);
  if (currentIndex == -1 || currentIndex >= levels.length - 1) return null;
  return levels[currentIndex + 1];
}
