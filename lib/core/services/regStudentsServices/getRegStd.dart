import '../../apiControl/apiManager.dart';
import '../../apiControl/apiServiceProvider.dart';
import '../../model/regStdModels/RegStResponse.dart';

class Getregstd {
  static Future<RegStdResponse> getRegStd({
    required String token,
    required String deviceId,
    required int DeviceType,
  }) async {
    final params = {
      "token": token,
      "deviceID": deviceId,
      "DeviceType": DeviceType,
    };

    print("🔹 API Params: $params");

    final response = await APIServices().apiRequest(APIManager.regStd, params);
    if (response["success"] == true && response["data"] != null) {
      final regStdResponse = RegStdResponse.fromJson(response["data"]);
      return regStdResponse;
    } else {
      throw Exception(response["message"] ?? "Login failed");
    }

  }
}