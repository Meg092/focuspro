import 'package:get/get.dart';

import 'ft_home_regular_logic.dart';

class FtHomeRegularBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      FtHomeRegularLogic(),
      permanent: true,
    );
  }
}
