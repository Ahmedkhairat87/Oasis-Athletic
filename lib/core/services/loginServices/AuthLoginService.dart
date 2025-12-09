



import '../../apiControl/apiManager.dart';
import '../../apiControl/apiServiceProvider.dart';
import '../../model/loginModels/LoginResponse.dart';

class AuthLoginService {
  static Future<LoginResponse> login({
    required String username,
    required String password,
    required String deviceId,
    required String DeviceType,
    required String fcmToken,
  }) async {
    final params = {
      "user": username,
      "pass": password,
      "deviceID": deviceId,
      "DeviceType": DeviceType,
      "FCM": fcmToken,
    };

    print(params);
    final response = await APIServices().apiRequest(APIManager.loginAPI, params);

    //final loginResponse = LoginResponse.fromJson(response);
    if (response["success"] == true && response["data"] != null) {
      final loginResponse = LoginResponse.fromJson(response["data"]);
      return loginResponse;
    } else {
      throw Exception(response["message"] ?? "Login failed");
    }

   // return loginResponse;
  }
}