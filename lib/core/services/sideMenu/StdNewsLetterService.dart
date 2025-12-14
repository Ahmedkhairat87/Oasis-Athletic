import 'package:shared_preferences/shared_preferences.dart';

import '../../apiControl/apiManager.dart';
import '../../apiControl/apiServiceProvider.dart';
import '../../model/sideMenu/NewsLetter.dart';

class StdNewsLetterService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<NewsLetter?> getNewsLetter() async {
    try {
      final token = await _getToken();

      if (token == null || token.isEmpty) {
        print("ERROR: Token not found!");
        return null;
      }

      final params = {
        "token": token,
        "Flag": 0,
      };

      final response = await APIServices().apiRequest(
        APIManager.getNewsLetter,
        params,
      );

      if (response == null || response is! Map<String, dynamic>) {
        return null;
      }

      return NewsLetter.fromJson(response);

    } catch (e, st) {
      print("EXCEPTION in StdNewsLetterService:");
      print(e);
      print(st);
      return null;
    }
  }
}