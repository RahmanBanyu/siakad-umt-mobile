import 'package:flutter/material.dart';

class KHSDetailScreen extends StatelessWidget {
  final List<Map<String, String>> khsDetail = [
    {
      "mataKuliah": "Algoritma Pemrogramman",
      "nilai": "A",
    },
    {
      "mataKuliah": "Kalkulus 1",
      "nilai": "B",
    },
    {
      "mataKuliah": "Arsitektur dan Organisasi Komputer",
      "nilai": "A",
    },
    {
      "mataKuliah": "Pengantar Teknologi Informasi",
      "nilai": "B",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail KHS"),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/khs");
          },
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: khsDetail.length,
        separatorBuilder: (_, __) => const Divider(
          color: Colors.grey,
          thickness: 0.5,
          height: 24,
        ),
        itemBuilder: (context, index) {
          final item = khsDetail[index];
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item["mataKuliah"]!,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ),
              Text(
                item["nilai"]!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C6700),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
