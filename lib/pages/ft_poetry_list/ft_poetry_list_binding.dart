import 'package:get/get.dart';
import 'ft_poetry_list_logic.dart';

class FtPoetryListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FtPoetryListLogic());
  }
}
