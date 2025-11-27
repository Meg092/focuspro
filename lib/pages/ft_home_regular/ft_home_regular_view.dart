import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ft_home_regular_logic.dart';

class FtHomeRegularView extends GetView<FtHomeRegularLogic> {
  const FtHomeRegularView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => controller.jbzs.value
              ? const CircularProgressIndicator(color: Colors.purple)
              : buildError(),
        ),
      ),
    );
  }

  Widget buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              controller.iowhsjr();
            },
            icon: const Icon(
              Icons.restart_alt,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
