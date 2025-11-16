import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  static const String baseUrl = "https://siakad-api-production.up.railway.app/api";

  /// LOGIN
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print("LOGIN RESPONSE STATUS: ${response.statusCode}");
      print("LOGIN RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "success": true,
          "token": data["token"] ?? data["data"]?["token"],
          "user": UserModel.fromJson(data["user"] ?? data["data"]?["user"]),
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          "success": false,
          "message": data["message"] ?? "Login gagal",
        };
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  /// REGISTER
  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );

      print("REGISTER RESPONSE STATUS: ${response.statusCode}");
      print("REGISTER RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          "success": true,
          "user": UserModel.fromJson(data["user"] ?? data["data"]?["user"]),
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          "success": false,
          "message": data["message"] ?? "Registrasi gagal",
        };
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  /// FORGOT PASSWORD
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/forgot-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      print("FORGOT PASSWORD STATUS: ${response.statusCode}");
      print("FORGOT PASSWORD BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "success": true,
          "message": data["message"] ?? "Email reset password terkirim",
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          "success": false,
          "message": data["message"] ?? "Gagal mengirim email reset",
        };
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  /// RESET PASSWORD (harus login)
  static Future<Map<String, dynamic>> resetPassword(
      String token, String oldPass, String newPass) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/reset-password"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({"old_password": oldPass, "new_password": newPass}),
      );

      print("RESET PASSWORD STATUS: ${response.statusCode}");
      print("RESET PASSWORD BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "success": true,
          "message": data["message"] ?? "Password berhasil diubah",
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          "success": false,
          "message": data["message"] ?? "Reset password gagal",
        };
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }
}
