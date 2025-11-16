import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/krs_model.dart';

class KRSService {
  static const String baseUrl =
      "https://siakad-api-production.up.railway.app/api";

  /// GET KRS by user
  static Future<List<KRSModel>> getKRSByUser(int userId, String token) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/krs/user/$userId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("GET KRS STATUS: ${response.statusCode}");
      print("GET KRS BODY: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Ambil List di bawah key "data"
        final List<dynamic> krsList = data["data"] ?? [];

        return krsList.map((e) => KRSModel.fromJson(e)).toList();
      } else {
        print("Gagal mengambil KRS: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error getKRSByUser: $e");
      return [];
    }
  }

  /// CREATE KRS dengan details (nested KRSDetail + Course)
  static Future<bool> createKRS(
      Map<String, dynamic> payload, String token) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/krs"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(payload),
      );

      print("CREATE KRS STATUS: ${response.statusCode}");
      print("CREATE KRS BODY: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Error createKRS: $e");
      return false;
    }
  }

  /// DELETE specific course from KRS
  static Future<bool> deleteKRS(int krsId, int detailId, String token) async {
    print(">>> delete KRS krsId:$krsId detailId:$detailId");
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/krs/$krsId/course/$detailId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("DELETE KRS STATUS: ${response.statusCode}");
      print("DELETE KRS BODY: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("Error deleteKRS: $e");
      return false;
    }
  }

  /// Optional: GET KRS by semester
  static Future<List<KRSModel>> getKRSBySemester(
      int userId, int semesterId, String token) async {
    try {
      final allKRS = await getKRSByUser(userId, token);
      return allKRS
          .where((k) => k.semesterId != null && k.semesterId == semesterId)
          .toList();
    } catch (e) {
      print("Error getKRSBySemester: $e");
      return [];
    }
  }

  /// ADD COURSE TO KRS
  static Future<bool> addCourseToKRS(
      int krsId, Map<String, dynamic> payload, String token) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/krs/$krsId/course"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(payload),
      );

      print("ADD COURSE STATUS: ${response.statusCode}");
      print("ADD COURSE BODY: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Error addCourseToKRS: $e");
      return false;
    }
  }
}
