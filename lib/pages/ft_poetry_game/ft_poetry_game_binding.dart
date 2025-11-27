import 'package:get/get.dart';
import 'ft_poetry_game_logic.dart';

class FtPoetryGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FtPoetryGameLogic());
  }
}
