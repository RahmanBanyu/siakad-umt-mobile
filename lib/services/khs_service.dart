import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/khs_model.dart';

class KHSService {
  static const String baseUrl =
      "https://siakad-api-production.up.railway.app/api";

  /// GET KHS
  static Future<List<KHSModel>> getKHS(String token) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/khs"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("GET KHS STATUS: ${response.statusCode}");
      print("GET KHS BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // Map<String, dynamic>

        // Ambil List di bawah key "data"
        final khsList = data["data"] as List<dynamic>;

        return khsList.map((e) => KHSModel.fromJson(e)).toList();
      } else {
        print("Gagal mengambil KHS: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error getKHS: $e");
      return [];
    }
  }

  /// CREATE KHS
  static Future<bool> createKHS(
      Map<String, dynamic> payload, String token) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/khs"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(payload),
      );

      print("CREATE KHS STATUS: ${response.statusCode}");
      print("CREATE KHS BODY: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Error createKHS: $e");
      return false;
    }
  }
}
