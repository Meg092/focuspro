import 'dart:async';
import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import '../../db_ft/database.dart';
import '../../db_ft/db_ft_entity.dart';
import '../../utils/index.dart';
import 'package:flutter/material.dart';

class FtListenRepeatLogic extends GetxController {
  final int digitCount = Get.arguments['digitCount'] ?? 3;
  final scoreBroadcast = true.obs;
  final isPlaying = false.obs;
  final hasPlayedOnce = false.obs;
  final userInput = <int>[].obs;
  final currentDigits = <int>[].obs;
  final waveHeights = <double>[30.0, 50.0, 70.0, 50.0, 30.0].obs;

  final FlutterTts _tts = FlutterTts();
  Timer? _inputTimer;
  Timer? _waveAnimationTimer;
  DateTime? _startTime;

  @override
  void onInit() {
    super.onInit();
    _initTts();
    _loadPreferences();
  }

  @override
  void onClose() {
    _tts.stop();
    _inputTimer?.cancel();
    _waveAnimationTimer?.cancel();
    super.onClose();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.4);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  Future<void> _loadPreferences() async {
    try {
      final value = await FtDatabase.instance.getBoolPreference(
        'score_broadcast',
        defaultValue: true,
      );
      scoreBroadcast.value = value;
    } catch (e) {
      errorToast('Failed to load preferences: ${e.toString()}');
    }
  }

  void onNumberTap(int number) {
    if (isPlaying.value) return;
    if (userInput.length >= digitCount) return;

    userInput.add(number);

    if (userInput.length == digitCount) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _checkAnswer();
      });
    }
  }

  void onDeleteTap() {
    if (isPlaying.value) return;
    if (userInput.isNotEmpty) {
      userInput.removeLast();
    }
  }

  void _startWaveAnimation() {
    _waveAnimationTimer?.cancel();
    _waveAnimationTimer = Timer.periodic(const Duration(milliseconds: 150), (
      timer,
    ) {
      if (!isPlaying.value) {
        timer.cancel();
        waveHeights.value = [30.0, 50.0, 70.0, 50.0, 30.0];
        return;
      }
      final random = Random();
      waveHeights.value = List.generate(
        5,
        (index) => 30.0 + random.nextDouble() * 50.0,
      );
    });
  }

  void _stopWaveAnimation() {
    _waveAnimationTimer?.cancel();
    waveHeights.value = [30.0, 50.0, 70.0, 50.0, 30.0];
  }

  Future<void> onPlayTap() async {
    if (isPlaying.value) {
      return;
    }

    try {
      final random = Random();
      currentDigits.value = List.generate(
        digitCount,
        (_) => random.nextInt(10),
      );
      userInput.clear();
      _startTime = DateTime.now();

      isPlaying.value = true;
      hasPlayedOnce.value = true;
      _startWaveAnimation();

      await Future.delayed(const Duration(milliseconds: 500));
      for (int i = 0; i < currentDigits.length; i++) {
        await _tts.speak(currentDigits[i].toString());
        await Future.delayed(const Duration(milliseconds: 800));
      }

      isPlaying.value = false;
      _stopWaveAnimation();
    } catch (e) {
      isPlaying.value = false;
      _stopWaveAnimation();
      errorToast('Failed to play audio: ${e.toString()}');
    }
  }

  Future<void> _checkAnswer() async {
    if (currentDigits.isEmpty) {
      errorToast('Please play audio first');
      return;
    }

    final isCorrect = _compareAnswers(currentDigits, userInput);
    final timeTaken = _startTime != null
        ? DateTime.now().difference(_startTime!).inMilliseconds / 1000.0
        : 0.0;

    final correctCount = isCorrect ? 1 : 0;
    final score = isCorrect ? (100 / (timeTaken + 1) * 10).round() : 0;

    await _saveRecord(correctCount, timeTaken, score);

    _showResultDialog(
      answer: currentDigits.join(),
      userAnswer: userInput.join(),
      isCorrect: isCorrect,
      timeTaken: timeTaken,
      score: score,
    );
  }

  bool _compareAnswers(List<int> correct, List<int> user) {
    if (correct.length != user.length) return false;
    for (int i = 0; i < correct.length; i++) {
      if (correct[i] != user[i]) return false;
    }
    return true;
  }

  Future<void> _saveRecord(
    int correctCount,
    double timeTaken,
    int score,
  ) async {
    try {
      final record = ListeningRecord(
        trainingType: 'repeat',
        totalQuestions: 1,
        correctCount: correctCount,
        avgTime: timeTaken,
        score: score,
        playTime: DateTime.now(),
      );

      await FtDatabase.instance.insertListeningRecord(record);
    } catch (e) {
      errorToast('Failed to save record: ${e.toString()}');
    }
  }

  void _showResultDialog({
    required String answer,
    required String userAnswer,
    required bool isCorrect,
    required double timeTaken,
    required int score,
  }) {
    final percentile = calculatePercentile(score, 'listen_repeat');

    if (scoreBroadcast.value) {
      _broadcastResult(isCorrect, score, percentile);
    }

    Get.dialog(
      Dialog(
        backgroundColor: Colors.black.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                size: 64,
                color: isCorrect
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
              ),
              const SizedBox(height: 16),
              Text(
                'Answer: $answer',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              if (!isCorrect) ...[
                const SizedBox(height: 8),
                Text(
                  'Your Answer: $userAnswer',
                  style: TextStyle(fontSize: 16, color: Colors.red.shade300),
                ),
              ],
              const SizedBox(height: 24),
              Text(
                '${score.toStringAsFixed(2)} pts',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Defeated $percentile% of players globally',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Correct: ${isCorrect ? 1 : 0}',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Time: ${formatTime(timeTaken)} s',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                        userInput.clear();
                        currentDigits.clear();
                        hasPlayedOnce.value = false;
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.refresh, size: 18),
                          SizedBox(width: 4),
                          Text('Retry'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        userInput.clear();
                        currentDigits.clear();
                        hasPlayedOnce.value = false;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                      ),
                      child: const Text('Confirm'),
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

  Future<void> _broadcastResult(
    bool isCorrect,
    int score,
    int percentile,
  ) async {
    try {
      await _tts.stop();

      if (isCorrect) {
        await _tts.speak('Correct!');
        await Future.delayed(const Duration(milliseconds: 800));
      } else {
        await _tts.speak('Wrong answer.');
        await Future.delayed(const Duration(milliseconds: 800));
      }

      await _tts.speak('Your score is $score points.');
      await Future.delayed(const Duration(milliseconds: 1000));

      await _tts.speak('You defeated $percentile percent of players globally.');
    } catch (e) {
      debugPrint('TTS broadcast failed: ${e.toString()}');
    }
  }

  Future<void> toggleScoreBroadcast() async {
    scoreBroadcast.value = !scoreBroadcast.value;
    try {
      await FtDatabase.instance.setPreference(
        'score_broadcast',
        scoreBroadcast.value.toString(),
      );
    } catch (e) {
      errorToast('Failed to save preference: ${e.toString()}');
    }
  }

  void onPageExit() {
    _tts.stop();
    _waveAnimationTimer?.cancel();
    isPlaying.value = false;
  }
}
