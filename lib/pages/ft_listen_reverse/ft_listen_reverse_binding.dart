import 'package:get/get.dart';
import 'ft_listen_reverse_logic.dart';

class FtListenReverseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FtListenReverseLogic());
  }
}
