import 'package:get/get.dart';
import 'ft_listen_categorize_logic.dart';

class FtListenCategorizeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FtListenCategorizeLogic());
  }
}
