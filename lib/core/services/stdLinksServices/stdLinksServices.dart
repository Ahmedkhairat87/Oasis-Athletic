import '../../apiControl/apiManager.dart';
import '../../apiControl/apiServiceProvider.dart';
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
import '../../model/stdLinks/StdLinks.dart';

class StudentLinksService {
  static final Dio _dio = Dio();

  static Future<StdLinks?> getStudentLinks({
    required String token,
    required String stdId,
  }) async {
    try {
      final url = APIManager.getStdLinks;
      final response = await _dio.post(
        url,
        data: {
          "token": token,
          "stdID": stdId,
        },
      );

      print(response.data);

      if (response.data == null || response.data is! Map) {
        return null;
      }

      final data = StdLinks.fromJson(response.data);


      return data;
    } catch (e, st) {
      print("EXCEPTION IN API:");
      print(e);
      print(st);
      return null;
    }
  }
}