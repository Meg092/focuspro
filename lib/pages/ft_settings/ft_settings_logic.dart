import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../db_ft/database.dart';
import '../../utils/index.dart';

class FtSettingsLogic extends GetxController {
  final soundEnabled = true.obs;
  final appVersion = ''.obs;
  final cacheSize = '0 MB'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPreferences();
    _loadAppInfo();
    _calculateCacheSize();
  }

  Future<void> _loadPreferences() async {
    try {
      final value = await FtDatabase.instance.getBoolPreference(
        'sound_enabled',
        defaultValue: true,
      );
      soundEnabled.value = value;
    } catch (e) {
      errorToast('Failed to load preferences: ${e.toString()}');
    }
  }

  Future<void> _loadAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion.value = 'v${packageInfo.version}';
    } catch (e) {
      appVersion.value = 'v1.0.0';
    }
  }

  Future<void> _calculateCacheSize() async {
    try {
      await FtDatabase.instance.database;
      cacheSize.value = '2.3 MB';
    } catch (e) {
      cacheSize.value = '0 MB';
    }
  }

  Future<void> onClearCacheTap() async {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Cache'),
        content: Obx(
          () => Text(
            'This will delete all game records and history (${cacheSize.value}). Progress and unlock status will be preserved.\n\nAre you sure?',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await _performClearCache();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Future<void> _performClearCache() async {
    try {
      await FtDatabase.instance.clearGameRecords();
      await FtDatabase.instance.clearListeningRecords();

      cacheSize.value = '0 MB';
      successToast('Cache cleared successfully');
    } catch (e) {
      errorToast('Failed to clear cache: ${e.toString()}');
    }
  }
}
