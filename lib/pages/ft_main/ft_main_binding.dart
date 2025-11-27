import 'package:get/get.dart';
import 'ft_main_logic.dart';
import '../ft_home/ft_home_logic.dart';
import '../ft_daily_listen/ft_daily_listen_logic.dart';
import '../ft_settings/ft_settings_logic.dart';

class FtMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FtMainLogic());
    Get.lazyPut(() => FtHomeLogic());
    Get.lazyPut(() => FtDailyListenLogic());
    Get.lazyPut(() => FtSettingsLogic());
  }
}
