import 'package:get/get.dart';
import 'ft_daily_listen_logic.dart';

class FtDailyListenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FtDailyListenLogic());
  }
}
