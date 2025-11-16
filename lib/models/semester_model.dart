class SemesterModel {
  final int id;
  final String year;
  final String term;
  final bool active;

  SemesterModel({
    required this.id,
    required this.year,
    required this.term,
    required this.active,
  });

  factory SemesterModel.fromJson(Map<String, dynamic> json) {
    return SemesterModel(
      id: json["id"],
      year: json["year"],
      term: json["term"],
      active: json["active"],
    );
  }
}
