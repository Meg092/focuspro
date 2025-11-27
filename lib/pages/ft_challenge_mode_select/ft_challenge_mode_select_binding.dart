import 'package:get/get.dart';
import 'ft_challenge_mode_select_logic.dart';

class FtChallengeModeSelectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FtChallengeModeSelectLogic());
  }
}
