import 'package:get/get.dart';
import 'ft_number_game_logic.dart';

class FtNumberGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FtNumberGameLogic());
  }
}
