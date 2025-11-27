import 'package:get/get.dart';
import 'ft_standard_logic.dart';

class FtStandardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FtStandardLogic());
  }
}
