import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

Future<Map<String, String>> getDeviceData() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  String deviceId = "unknown";
  String deviceType = "unknown";

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;

    deviceId = androidInfo.id; // ✅ Unique per device
    deviceType = "2";

    print("✅ Android ID: $deviceId");
  }
  else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;

    deviceId = iosInfo.identifierForVendor ?? "unknown";
    deviceType = "1";

    print("✅ iOS ID: $deviceId");
  }

  return {
    "deviceId": deviceId,
    "deviceType": deviceType,
  };
}