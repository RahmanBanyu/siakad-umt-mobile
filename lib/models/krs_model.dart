class KRSModel {
  final int? id;
  final int? userId;
  final int? semesterId;
  final bool? finalized;
  final String? createdAt;
  final String? updatedAt;
  final List<KRSDetailModel>? details; // sebelumnya courses

  KRSModel({
    this.id,
    this.userId,
    this.semesterId,
    this.finalized,
    this.createdAt,
    this.updatedAt,
    this.details,
  });

  factory KRSModel.fromJson(Map<String, dynamic> json) {
    return KRSModel(
      id: json['id'],
      userId: json['user_id'],
      semesterId: json['semester_id'],
      finalized: json['finalized'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      details: json['details'] != null
          ? (json['details'] as List)
              .map((d) => KRSDetailModel.fromJson(d))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'semester_id': semesterId,
      'finalized': finalized,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'details': details?.map((d) => d.toJson()).toList(),
    };
  }
}

class KRSDetailModel {
  final int? id;
  final int? krsId;
  final int? courseId;
  final String? grade;
  final Course? course;
  final String? createdAt;
  final String? updatedAt;

  KRSDetailModel({
    this.id,
    this.krsId,
    this.courseId,
    this.grade,
    this.course,
    this.createdAt,
    this.updatedAt,
  });

  factory KRSDetailModel.fromJson(Map<String, dynamic> json) {
    return KRSDetailModel(
      id: json['id'],
      krsId: json['krs_id'],
      courseId: json['course_id'],
      grade: json['grade'],
      course: json['Course'] != null ? Course.fromJson(json['Course']) : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'krs_id': krsId,
      'course_id': courseId,
      'grade': grade,
      'course': course?.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Course {
  final int? id;
  final String? courseCode;
  final String? courseName;
  final String? lecturer;
  final int? sks;

  Course({
    this.id,
    this.courseCode,
    this.courseName,
    this.lecturer,
    this.sks,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      courseCode: json['course_code'],
      courseName: json['course_name'],
      lecturer: json['lecturer'],
      sks: json['sks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_code': courseCode,
      'course_name': courseName,
      'lecturer': lecturer,
      'sks': sks,
    };
  }
}
