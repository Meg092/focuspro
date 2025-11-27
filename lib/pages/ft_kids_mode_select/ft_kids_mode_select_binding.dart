import 'package:get/get.dart';
import 'ft_kids_mode_select_logic.dart';

class FtKidsModeSelectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FtKidsModeSelectLogic());
  }
}
