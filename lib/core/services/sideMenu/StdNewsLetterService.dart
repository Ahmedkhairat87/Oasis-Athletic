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
      if (token == null || token.isEmpty) return null;

      final response = await APIServices().apiRequest(
        APIManager.getNewsLetter,
        {
          "token": token,
          "Flag": 0,
        },
      );

      final parsed = NewsLetter.fromJson(response);

      // 🔍 DEBUG — YOU WILL SEE COUNT > 0
      print("📰 Parsed newsletters count: ${parsed.data.length}");

      return parsed;
    } catch (e, st) {
      print("❌ Newsletter service error");
      print(e);
      print(st);
      return null;
    }
  }
}