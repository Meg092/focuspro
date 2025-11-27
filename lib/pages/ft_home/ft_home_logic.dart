import 'package:get/get.dart';

class FtHomeLogic extends GetxController {
  void onStandardModeTap() {
    Get.toNamed('/ft_standard_mode');
  }

  void onPoetryModeTap() {
    Get.toNamed('/ft_poetry_mode');
  }

  void onKidsModeTap() {
    Get.toNamed('/ft_kids_mode');
  }

  void onChallengeModeTap() {
    Get.toNamed('/ft_challenge_mode');
  }

  void onCrazyModeTap() {
    Get.toNamed('/ft_crazy_mode');
  }

  void onListeningModeTap() {
    Get.toNamed('/ft_listening_training');
  }
}
