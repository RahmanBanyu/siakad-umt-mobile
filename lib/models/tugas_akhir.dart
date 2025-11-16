class TugasAkhir {
  final int? id;
  final int? userId;
  final String? category;

  final String? studentName;
  final String? studentNim;

  final String? title;
  final String? researchPlace;
  final String? unit;
  final String? address;

  final String? companyEmail;
  final String? companyPhone;

  final String? createdAt;
  final String? updatedAt;

  TugasAkhir({
    this.id,
    this.userId,
    this.category,
    this.studentName,
    this.studentNim,
    this.title,
    this.researchPlace,
    this.unit,
    this.address,
    this.companyEmail,
    this.companyPhone,
    this.createdAt,
    this.updatedAt,
  });

  factory TugasAkhir.fromJson(Map<String, dynamic> json) {
    return TugasAkhir(
      id: json['id'],
      userId: json['user_id'],
      category: json['category'],
      studentName: json['student_name'],
      studentNim: json['student_nim'],
      title: json['title'],
      researchPlace: json['research_place'],
      unit: json['unit'],
      address: json['address'],
      companyEmail: json['company_email'],
      companyPhone: json['company_phone'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'category': category,
      'student_name': studentName,
      'student_nim': studentNim,
      'title': title,
      'research_place': researchPlace,
      'unit': unit,
      'address': address,
      'company_email': companyEmail,
      'company_phone': companyPhone,
    };
  }
}
