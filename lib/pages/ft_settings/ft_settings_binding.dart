import 'package:get/get.dart';
import 'ft_settings_logic.dart';

class FtSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FtSettingsLogic());
  }
}
