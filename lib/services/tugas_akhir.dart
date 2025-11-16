import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:siakad_ft/models/tugas_akhir.dart';

class TugasAkhirService {
  static const String baseUrl =
      "https://siakad-api-production.up.railway.app/api";

  /// CREATE Tugas Akhir
  static Future<bool> createTA(
      Map<String, dynamic> payload, String token) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/tugas-akhir"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(payload),
      );

      print("CREATE TA STATUS: ${response.statusCode}");
      print("CREATE TA BODY: ${response.body}");

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print("Error createTA: $e");
      return false;
    }
  }

  /// GET Tugas Akhir berdasarkan kategori: skripsi / kp
  static Future<List<TugasAkhir>> getByCategory(
      String category, String token) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/tugas-akhir/$category"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      print("GET TA CATEGORY STATUS: ${response.statusCode}");
      print("GET TA CATEGORY BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data["data"] as List<dynamic>;
        return list.map((e) => TugasAkhir.fromJson(e)).toList();
      } else {
        print("Gagal mengambil TA kategori: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error getByCategory TA: $e");
      return [];
    }
  }
}
