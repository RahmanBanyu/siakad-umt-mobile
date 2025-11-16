import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/payment_model.dart';

class PaymentService {
  static const String baseUrl =
      "https://siakad-api-production.up.railway.app/api";

  /// GET all payments
  static Future<List<PaymentModel>> getPayments(String token) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/payments"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("GET PAYMENTS STATUS: ${response.statusCode}");
      print("GET PAYMENTS BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.map((e) => PaymentModel.fromJson(e)).toList();
      } else {
        print("Gagal mengambil payments: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error getPayments: $e");
      return [];
    }
  }

  /// GET payments by user
  static Future<List<PaymentModel>> getPaymentsByUser(
      int userId, String token) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/payments/user/$userId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("GET PAYMENTS BY USER STATUS: ${response.statusCode}");
      print("GET PAYMENTS BY USER BODY: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> list = decoded["data"] ?? [];
        return list.map((e) => PaymentModel.fromJson(e)).toList();
      } else {
        print("Gagal mengambil payments user: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error getPaymentsByUser: $e");
      return [];
    }
  }

  /// CREATE payment
  static Future<bool> createPayment(
      Map<String, dynamic> payload, String token) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/payments"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(payload),
      );

      print("CREATE PAYMENT STATUS: ${response.statusCode}");
      print("CREATE PAYMENT BODY: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Error createPayment: $e");
      return false;
    }
  }
}
