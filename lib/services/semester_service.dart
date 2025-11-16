import '../core/network/dio_client.dart';
import '../models/semester_model.dart';

class SemesterService {
  static Future<List<SemesterModel>> getSemesters() async {
    final res = await DioClient.dio.get("/semester");

    return (res.data as List)
        .map((e) => SemesterModel.fromJson(e))
        .toList();
  }
}
