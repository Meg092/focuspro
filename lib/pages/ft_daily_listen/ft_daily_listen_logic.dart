import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import '../../utils/index.dart';

class FtDailyListenLogic extends GetxController {
  final isBlurred = true.obs;
  final isPlaying = false.obs;
  final blurAmount = 10.0.obs;
  final currentSentence = ''.obs;
  final currentTranslation = ''.obs;
  final progress = 0.0.obs;

  final FlutterTts _tts = FlutterTts();

  final List<Map<String, String>> _sentences = [
    {
      'en': 'The journey of a thousand miles begins with a single step.',
      'cn': '千里之行，始于足下。',
    },
    {'en': 'Where there is a will, there is a way.', 'cn': '有志者事竟成。'},
    {
      'en':
          'Success is not final, failure is not fatal: it is the courage to continue that counts.',
      'cn': '成功不是终点，失败也并非末日，重要的是继续前行的勇气。',
    },
    {
      'en': 'Believe you can and you are halfway there.',
      'cn': '相信自己能做到，你就已经成功了一半。',
    },
    {
      'en': 'The only way to do great work is to love what you do.',
      'cn': '成就伟大事业的唯一途径就是热爱你的工作。',
    },
    {
      'en': 'Focus on being productive instead of busy.',
      'cn': '专注于高效工作，而不是瞎忙活。',
    },
    {
      'en': 'The secret of getting ahead is getting started.',
      'cn': '成功的秘诀就是开始行动。',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _initTts();
    _selectDailySentence();
  }

  @override
  void onClose() {
    _tts.stop();
    super.onClose();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.4);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  void _selectDailySentence() {
    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    final index = dayOfYear % _sentences.length;
    final sentence = _sentences[index];

    currentSentence.value = sentence['en']!;
    currentTranslation.value = sentence['cn']!;
  }

  Future<void> playAudio() async {
    if (isPlaying.value) return;

    try {
      isPlaying.value = true;
      isBlurred.value = true;
      blurAmount.value = 10.0;
      progress.value = 0.0;

      int currentIndex = _sentences.indexWhere(
        (s) => s['en'] == currentSentence.value,
      );

      int newIndex;
      do {
        newIndex = DateTime.now().millisecondsSinceEpoch % _sentences.length;
      } while (newIndex == currentIndex && _sentences.length > 1);

      final sentence = _sentences[newIndex];
      currentSentence.value = sentence['en']!;
      currentTranslation.value = sentence['cn']!;

      final estimatedDuration = (currentSentence.value.split(' ').length * 0.6)
          .ceil();

      _tts.speak(currentSentence.value);

      await _animatePlayback(estimatedDuration);

      isPlaying.value = false;
    } catch (e) {
      isPlaying.value = false;
      progress.value = 0.0;
      errorToast('Failed to play audio: ${e.toString()}');
    }
  }

  Future<void> _animatePlayback(int durationSeconds) async {
    const updateInterval = 50;
    final totalSteps = (durationSeconds * 1000) ~/ updateInterval;

    for (int step = 0; step <= totalSteps; step++) {
      progress.value = step / totalSteps;

      blurAmount.value = 10.0 * (1 - progress.value);

      await Future.delayed(const Duration(milliseconds: updateInterval));
    }

    progress.value = 1.0;
    blurAmount.value = 0.0;
    isBlurred.value = false;
  }
}
