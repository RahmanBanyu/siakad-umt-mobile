import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  static const String baseUrl =
      "https://siakad-api-production.up.railway.app/api";

  /// GET CURRENT USER
  static Future<Map<String, dynamic>> me(String token) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/me"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("ME RESPONSE STATUS: ${response.statusCode}");
      print("ME RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "success": true,
          "user": UserModel.fromJson(data["user"] ?? data["data"]?["user"]),
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          "success": false,
          "message": data["message"] ?? "Gagal mengambil data user",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }
}
