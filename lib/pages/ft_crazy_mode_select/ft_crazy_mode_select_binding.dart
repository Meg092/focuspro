import 'package:get/get.dart';
import 'ft_crazy_mode_select_logic.dart';

class FtCrazyModeSelectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FtCrazyModeSelectLogic());
  }
}
