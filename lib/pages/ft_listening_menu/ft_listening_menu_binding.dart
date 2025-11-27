import 'package:get/get.dart';
import 'ft_listening_menu_logic.dart';

class FtListeningMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FtListeningMenuLogic());
  }
}
