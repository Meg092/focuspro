import 'package:get/get.dart';
import 'ft_listen_repeat_logic.dart';

class FtListenRepeatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FtListenRepeatLogic());
  }
}
