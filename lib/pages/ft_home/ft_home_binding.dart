import 'package:get/get.dart';
import 'ft_home_logic.dart';

class FtHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FtHomeLogic());
  }
}
