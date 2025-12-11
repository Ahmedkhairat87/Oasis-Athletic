import '../../apiControl/apiManager.dart';
import '../../model/stdLinks/StdLinks.dart';

// class StudentLinksService {
//   static Future<StdLinks> getStudentLinks({
//     required String token,
//     required String stdId,
//   }) async {
//     final params = {
//       "token": token,
//       "std_id": stdId,
//     };
//
//     final response = await APIServices().apiRequest(
//       APIManager.getStdLinks,
//       params,
//     );
//
//     return StdLinks.fromJson(response);
//   }
// }

import 'package:dio/dio.dart';

class StudentLinksService {
  static final Dio _dio = Dio();

  static Future<StdLinks?> getStudentLinks({
    required String token,
    required String stdId,
  }) async {
    try {
      final url = APIManager.getStdLinks;

      print("🚀 Fetching Student Links...");
      print("URL: $url");
      print("PARAMS:");
      print("token = $token");
      print("stdId = $stdId");

      final response = await _dio.post(
        url,
        data: {
          "token": token,
          "stdID": stdId,
        },
      );

      print("📥 RAW RESPONSE:");
      print(response.data);

      // تأكد إنه JSON Map
      if (response.data == null || response.data is! Map) {
        print("❌ ERROR: Response is null or not JSON object");
        return null;
      }

      // حوّل للـ model
      final data = StdLinks.fromJson(response.data);

      print("✅ Parsing Done!");
      print("➡ Main Links Count: ${data.stdMainLinks?.length}");
      print("➡ Full Data Count: ${data.stdFullData?.length}");
      print("➡ Sports Count: ${data.stdSports?.length}");

      return data;
    } catch (e, st) {
      print("❌ EXCEPTION IN API:");
      print(e);
      print(st);
      return null;
    }
  }
}