import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class APIServices {

  Future<Map<String, dynamic>> apiRequest(
      String path, Map<String, dynamic> params) async {

    try {
      Uri uri = Uri.parse(path);

      final response = await http
          .post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(params),
      )
          .timeout(const Duration(seconds: 20));

      print("🔹 Status Code: ${response.statusCode}");
      print("🔹 Response: ${response.body}");

      // ---- SUCCESS ----
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          "success": true,
          "data": jsonDecode(response.body),
          "message": "Request successful",
          "statusCode": response.statusCode
        };
      }

      // ---- NO CONTENT (204) ----
      if (response.statusCode == 204) {
        return {
          "success": false,
          "data": null,
          "message": "No data found",
          "statusCode": 204
        };
      }

      // ---- CLIENT ERRORS (400–499) ----
      if (response.statusCode >= 400 && response.statusCode < 500) {
        return {
          "success": false,
          "data": null,
          "message": _clientErrorMessage(response),
          "statusCode": response.statusCode
        };
      }

      // ---- SERVER ERRORS (500–599) ----
      if (response.statusCode >= 500) {
        return {
          "success": false,
          "data": null,
          "message": "Server error, please try again later",
          "statusCode": response.statusCode
        };
      }

      // ---- UNKNOWN ----
      return {
        "success": false,
        "data": null,
        "message": "Unexpected error occurred",
        "statusCode": response.statusCode
      };

    } on SocketException {
      return {
        "success": false,
        "message": "No Internet connection",
        "data": null,
        "statusCode": 0
      };
    } on FormatException {
      return {
        "success": false,
        "message": "Invalid response format",
        "data": null,
        "statusCode": 0
      };
    } on HttpException {
      return {
        "success": false,
        "message": "Couldn't get response from the server",
        "data": null,
        "statusCode": 0
      };
    } on TimeoutException {
      return {
        "success": false,
        "message": "Connection timed out",
        "data": null,
        "statusCode": 0
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Unexpected error: $e",
        "data": null,
        "statusCode": 0
      };
    }
  }

  // Return user-friendly messages for 400 errors
  String _clientErrorMessage(http.Response response) {
    try {
      final json = jsonDecode(response.body);
      if (json is Map && json.containsKey("message")) {
        return json["message"];
      }
    } catch (_) {}
    return "Request failed (${response.statusCode})";
  }
}