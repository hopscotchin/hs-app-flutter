import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceUtils {
  DeviceUtils._();

  static Future<bool> isIosSimulator() async {
    if (!Platform.isIOS) return false;
    final iosInfo = await DeviceInfoPlugin().iosInfo;
    return !iosInfo.isPhysicalDevice;
  }

  static Future<bool> isAndroidSimulator() async {
    if (!Platform.isAndroid) return false;
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return !androidInfo.isPhysicalDevice;
  }

  static Future<bool> isSimulator() async {
    return await isIosSimulator() || await isAndroidSimulator();
  }
}
