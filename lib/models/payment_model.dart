class PaymentModel {
  final int id;
  final int semesterId; // baru
  final double amount;
  final String description;
  final bool paid;

  PaymentModel({
    required this.id,
    required this.semesterId,
    required this.amount,
    required this.description,
    required this.paid,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json["id"],
      semesterId: json["semester_id"], // pastikan JSON API ada key ini
      amount: json["amount"].toDouble(),
      description: json["description"],
      paid: json["paid"],
    );
  }
}
