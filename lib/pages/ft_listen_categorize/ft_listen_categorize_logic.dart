import 'dart:async';
import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import '../../db_ft/database.dart';
import '../../db_ft/db_ft_entity.dart';
import '../../utils/index.dart';
import 'package:flutter/material.dart';

class FtListenCategorizeLogic extends GetxController {
  final categoryType = Get.arguments['categoryType'].toString();
  final scoreBroadcast = true.obs;
  final actionHints = true.obs;
  final isPlaying = false.obs;
  final currentWord = ''.obs;
  final showFeedback = false.obs;
  final isCorrectAnswer = false.obs;

  final FlutterTts _tts = FlutterTts();
  final waveHeights = <double>[30.0, 50.0, 70.0, 50.0, 30.0].obs;
  Timer? _waveAnimationTimer;
  Timer? _responseTimer;
  bool _waitingForResponse = false;
  final int _responseTimeout = 4;

  static final Map<String, List<String>> _wordSets = {
    'letters': [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z',
    ],
    'vegetables': [
      'Tomato',
      'Carrot',
      'Broccoli',
      'Potato',
      'Cucumber',
      'Spinach',
      'Lettuce',
      'Onion',
      'Cabbage',
      'Pepper',
      'Pumpkin',
      'Radish',
      'Eggplant',
      'Zucchini',
      'Leek',
      'Garlic',
      'Ginger',
      'Asparagus',
      'Celery',
      'Cauliflower',
    ],
    'fruits': [
      'Apple',
      'Banana',
      'Orange',
      'Grape',
      'Strawberry',
      'Watermelon',
      'Mango',
      'Pear',
      'Peach',
      'Cherry',
      'Pineapple',
      'Papaya',
      'Lemon',
      'Lime',
      'Blueberry',
      'Raspberry',
      'Plum',
      'Kiwi',
      'Coconut',
      'Apricot',
    ],
    'animals': [
      'Dog',
      'Cat',
      'Lion',
      'Elephant',
      'Tiger',
      'Bear',
      'Monkey',
      'Rabbit',
      'Horse',
      'Fox',
      'Wolf',
      'Giraffe',
      'Zebra',
      'Sheep',
      'Goat',
      'Pig',
      'Cow',
      'Deer',
      'Camel',
      'Kangaroo',
    ],
    'plants': [
      'Rose',
      'Tulip',
      'Sunflower',
      'Bamboo',
      'Cactus',
      'Fern',
      'Lily',
      'Daisy',
      'Orchid',
      'Lavender',
      'Jasmine',
      'Magnolia',
      'Ivy',
      'Lotus',
      'Begonia',
      'Violet',
      'Cypress',
      'Willow',
      'Maple',
      'Oak',
    ],
    'numbers': [
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
      'Ten',
      'Eleven',
      'Twelve',
      'Thirteen',
      'Fourteen',
      'Fifteen',
      'Sixteen',
      'Seventeen',
      'Eighteen',
      'Nineteen',
      'Twenty',
    ],
    'birds': [
      'Sparrow',
      'Eagle',
      'Parrot',
      'Owl',
      'Crow',
      'Swan',
      'Pigeon',
      'Robin',
      'Peacock',
      'Woodpecker',
      'Seagull',
      'Falcon',
      'Hawk',
      'Heron',
      'Stork',
      'Canary',
      'Kingfisher',
      'Magpie',
      'Nightingale',
      'Pelican',
    ],
    'insects': [
      'Butterfly',
      'Bee',
      'Ant',
      'Mosquito',
      'Ladybug',
      'Grasshopper',
      'Dragonfly',
      'Cricket',
      'Firefly',
      'Beetle',
      'Cockroach',
      'Wasp',
      'Termite',
      'Moth',
      'Fly',
      'Centipede',
      'Millipede',
      'Scarab',
      'Cicada',
      'Stick insect',
    ],
    'fish': [
      'Salmon',
      'Tuna',
      'Goldfish',
      'Shark',
      'Clownfish',
      'Catfish',
      'Cod',
      'Bass',
      'Trout',
      'Pike',
      'Carp',
      'Mackerel',
      'Anchovy',
      'Herring',
      'Grouper',
      'Swordfish',
      'Flounder',
      'Perch',
      'Tilefish',
      'Sturgeon',
    ],
  };

  List<Map<String, String>> _wordList = [];

  List<Map<String, String>> _gameWords = [];
  int _currentIndex = 0;
  int _correctCount = 0;
  final int _totalQuestions = 10;
  final List<double> _questionTimes = [];
  DateTime? _questionStartTime;

  Map<String, dynamic> get categoryInfo {
    final categories = categoryType.split(' vs ');
    if (categories.length != 2) {
      Get.back();
    }

    return {
      'category1': _getCategoryDetails(categories[0].trim()),
      'category2': _getCategoryDetails(categories[1].trim()),
    };
  }

  Map<String, String> _getCategoryDetails(String categoryName) {
    final categoryMap = {
      'Vegetables': {'name': 'Vegetables', 'emoji': '🥕', 'key': 'vegetables'},
      'Fruits': {'name': 'Fruits', 'emoji': '🍎', 'key': 'fruits'},
      'Animals': {'name': 'Animals', 'emoji': '🐶', 'key': 'animals'},
      'Plants': {'name': 'Plants', 'emoji': '🌿', 'key': 'plants'},
      'Numbers': {'name': 'Numbers', 'emoji': '🔢', 'key': 'numbers'},
      'Letters': {'name': 'Letters', 'emoji': '🔤', 'key': 'letters'},
      'Birds': {'name': 'Birds', 'emoji': '🦜', 'key': 'birds'},
      'Insects': {'name': 'Insects', 'emoji': '🦋', 'key': 'insects'},
      'Fish': {'name': 'Fish', 'emoji': '🐟', 'key': 'fish'},
    };

    return categoryMap[categoryName] ??
        {
          'name': categoryName,
          'emoji': '📦',
          'key': categoryName.toLowerCase(),
        };
  }

  List<String> _generateInstructionText() {
    final categories = categoryType.split(' vs ');
    if (categories.length != 2) {
      return [];
    }

    final cat1 = categories[0].trim();
    final cat2 = categories[1].trim();

    return [
      'When you hear $cat1, raise your left hand.',
      'When you hear $cat2, raise your right hand.',
    ];
  }

  @override
  void onInit() {
    super.onInit();
    _loadWordList();
    _initTts();
    _loadPreferences();
  }

  void _loadWordList() {
    final categories = categoryType.split(' vs ');
    if (categories.length != 2) {
      _wordList = _buildWordList('vegetables', 'fruits');
      return;
    }

    final category1 = _normalizeCategory(categories[0].trim());
    final category2 = _normalizeCategory(categories[1].trim());

    _wordList = _buildWordList(category1, category2);
  }

  String _normalizeCategory(String categoryName) {
    return categoryName.toLowerCase();
  }

  List<Map<String, String>> _buildWordList(
    String category1Key,
    String category2Key,
  ) {
    final words1 = _wordSets[category1Key] ?? [];
    final words2 = _wordSets[category2Key] ?? [];

    final List<Map<String, String>> result = [];

    final shuffledWords1 = List<String>.from(words1)..shuffle();
    final shuffledWords2 = List<String>.from(words2)..shuffle();

    final selectedWords1 = shuffledWords1.take(6).toList();
    final selectedWords2 = shuffledWords2.take(6).toList();

    for (var word in selectedWords1) {
      result.add({'word': word, 'category': category1Key});
    }

    for (var word in selectedWords2) {
      result.add({'word': word, 'category': category2Key});
    }

    result.shuffle(Random());

    return result;
  }

  @override
  void onClose() {
    _tts.stop();
    _responseTimer?.cancel();
    _waveAnimationTimer?.cancel();
    super.onClose();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  Future<void> _loadPreferences() async {
    try {
      final scoreBroadcastValue = await FtDatabase.instance.getBoolPreference(
        'score_broadcast',
        defaultValue: true,
      );
      final actionHintsValue = await FtDatabase.instance.getBoolPreference(
        'action_hints',
        defaultValue: true,
      );

      scoreBroadcast.value = scoreBroadcastValue;
      actionHints.value = actionHintsValue;
    } catch (e) {
      errorToast('Failed to load preferences: ${e.toString()}');
    }
  }

  Future<void> _playCurrentWord() async {
    if (_currentIndex >= _gameWords.length) {
      _showCompletionDialog();
      return;
    }

    try {
      final wordData = _gameWords[_currentIndex];
      currentWord.value = wordData['word']!;
      _questionStartTime = DateTime.now();

      isPlaying.value = true;
      _startWaveAnimation();

      _waitingForResponse = true;

      _responseTimer?.cancel();
      _responseTimer = Timer(Duration(seconds: _responseTimeout), () {
        _handleTimeout();
      });

      await _tts.speak(wordData['word']!);
      await Future.delayed(const Duration(milliseconds: 800));

      isPlaying.value = false;
      _stopWaveAnimation();
    } catch (e) {
      isPlaying.value = false;
      _stopWaveAnimation();
      _waitingForResponse = false;
      _responseTimer?.cancel();
      errorToast('Failed to play audio: ${e.toString()}');
    }
  }

  Future<void> onCategory1Tap() async {
    final category1Key = categoryInfo['category1']['key'];
    await _handleAnswer(category1Key);
  }

  Future<void> onCategory2Tap() async {
    final category2Key = categoryInfo['category2']['key'];
    await _handleAnswer(category2Key);
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
      isPlaying.value = true;
      _startWaveAnimation();

      final instructionTexts = _generateInstructionText();
      for (var instructionText in instructionTexts) {
        await _tts.speak(instructionText);
        await Future.delayed(const Duration(milliseconds: 1000));
      }
      await Future.delayed(const Duration(milliseconds: 2000));

      final shuffled = List<Map<String, String>>.from(_wordList);
      _gameWords = shuffled.take(_totalQuestions).toList();

      _currentIndex = 0;
      _correctCount = 0;
      _questionTimes.clear();

      await _playCurrentWord();

      isPlaying.value = false;
      _stopWaveAnimation();
    } catch (e) {
      isPlaying.value = false;
      _stopWaveAnimation();
      errorToast('Failed to play audio: ${e.toString()}');
    }
  }

  Future<void> _handleAnswer(String selectedCategory) async {
    if (isPlaying.value || _currentIndex >= _gameWords.length) return;
    if (!_waitingForResponse) return;

    _responseTimer?.cancel();
    _waitingForResponse = false;

    final wordData = _gameWords[_currentIndex];
    final correctCategory = wordData['category']!;
    final isCorrect = selectedCategory == correctCategory;

    final timeTaken = _questionStartTime != null
        ? DateTime.now().difference(_questionStartTime!).inMilliseconds / 1000.0
        : 0.0;
    _questionTimes.add(timeTaken);

    if (isCorrect) {
      _correctCount++;
    }

    isCorrectAnswer.value = isCorrect;
    showFeedback.value = true;

    await Future.delayed(const Duration(milliseconds: 1000));
    showFeedback.value = false;

    _currentIndex++;
    await Future.delayed(const Duration(milliseconds: 500));
    await _playCurrentWord();
  }

  Future<void> _handleTimeout() async {
    if (!_waitingForResponse) return;

    _waitingForResponse = false;

    final timeTaken = _questionStartTime != null
        ? DateTime.now().difference(_questionStartTime!).inMilliseconds / 1000.0
        : 0.0;
    _questionTimes.add(timeTaken);

    isCorrectAnswer.value = false;
    showFeedback.value = true;

    await Future.delayed(const Duration(milliseconds: 1000));
    showFeedback.value = false;

    _currentIndex++;
    await Future.delayed(const Duration(milliseconds: 500));
    await _playCurrentWord();
  }

  void _showCompletionDialog() async {
    final avgTime = _questionTimes.isEmpty
        ? 0.0
        : _questionTimes.reduce((a, b) => a + b) / _questionTimes.length;

    final score = (_correctCount / _totalQuestions * 100).round();
    final percentile = calculatePercentile(score, 'listen_categorize');

    if (scoreBroadcast.value) {
      _broadcastResult(_correctCount, _totalQuestions, score, percentile);
    }

    await _saveRecord(_correctCount, avgTime, score);

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
                _correctCount >= _totalQuestions * 0.7
                    ? Icons.emoji_events
                    : Icons.star,
                size: 64,
                color: const Color(0xFF4ADE80),
              ),
              const SizedBox(height: 16),
              const Text(
                'Training Complete!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '$score pts',
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
                    'Correct: $_correctCount/$_totalQuestions',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Avg Time: ${formatTime(avgTime)} s',
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
                      onPressed: () => Get.back(closeOverlays: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4ADE80),
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

  Future<void> _saveRecord(int correctCount, double avgTime, int score) async {
    try {
      final record = ListeningRecord(
        trainingType: 'categorize',
        totalQuestions: _totalQuestions,
        correctCount: correctCount,
        avgTime: avgTime,
        score: score,
        playTime: DateTime.now(),
      );

      await FtDatabase.instance.insertListeningRecord(record);
    } catch (e) {
      errorToast('Failed to save record: ${e.toString()}');
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

  Future<void> _broadcastResult(
    int correctCount,
    int totalQuestions,
    int score,
    int percentile,
  ) async {
    try {
      await _tts.stop();

      await _tts.speak('Training complete!');
      await Future.delayed(const Duration(milliseconds: 1000));

      await _tts.speak('You got $correctCount out of $totalQuestions correct.');
      await Future.delayed(const Duration(milliseconds: 1000));

      await _tts.speak('Your score is $score points.');
      await Future.delayed(const Duration(milliseconds: 1000));

      await _tts.speak('You defeated $percentile percent of players globally.');
    } catch (e) {
      debugPrint('TTS broadcast failed: ${e.toString()}');
    }
  }
}
