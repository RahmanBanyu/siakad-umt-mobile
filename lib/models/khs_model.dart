class KHSModel {
  final int? id;
  final int? userId;
  final int? semesterId;
  final double? gpa;
  final String? createdAt;
  final String? updatedAt;
  final List<KRSDetailModel>? details; // daftar KRSDetail (course + grade)

  KHSModel({
    this.id,
    this.userId,
    this.semesterId,
    this.gpa,
    this.createdAt,
    this.updatedAt,
    this.details,
  });

  factory KHSModel.fromJson(Map<String, dynamic> json) {
    return KHSModel(
      id: json['id'],
      userId: json['user_id'],
      semesterId: json['semester_id'],
      gpa: json['gpa'] != null ? (json['gpa'] as num).toDouble() : null,
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
      'gpa': gpa,
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
  final int? sks;
  final String? grade;
  final Course? course; // nested info course
  final String? createdAt;
  final String? updatedAt;

  KRSDetailModel({
    this.id,
    this.krsId,
    this.courseId,
    this.sks,
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
      course: (json['course'] ?? json['Course']) != null
          ? Course.fromJson(json['course'] ?? json['Course'])
          : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'krs_id': krsId,
      'course_id': courseId,
      'sks': sks,
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
      sks: json['sks'],
      lecturer: json['lecturer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_code': courseCode,
      'course_name': courseName,
      'sks': sks,
      'lecturer': lecturer,
    };
  }
}
