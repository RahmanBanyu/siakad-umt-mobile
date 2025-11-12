import 'package:flutter/material.dart';

class KRSDetailScreen extends StatelessWidget {
  final List<Map<String, String>> krsDetail = [
    {
      "mataKuliah": "Mobile Programming",
      "waktu": "Senin, 08:30 - 10:00 WIB",
      "ruang": "Ruang A12.7",
      "dosen": "Syepry Maulana Husain, S.Kom, MTI",
      "gradientStart": "#150C90",
      "gradientEnd": "#EFB1E2",
    },
    {
      "mataKuliah": "Analisis dan Perancangan Sistem Informasi",
      "waktu": "Senin, 08:30 - 10:00 WIB",
      "ruang": "Ruang A12.7",
      "dosen": "Yani Sugiani, M.Kom",
      "gradientStart": "#E8AD0D",
      "gradientEnd": "#EFB1E2",
    },
  ];

  Color hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xff')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail KRS"),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: krsDetail.length,
        itemBuilder: (context, index) {
          final item = krsDetail[index];
          return Container(
            margin: EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  hexToColor(item["gradientStart"]!),
                  hexToColor(item["gradientEnd"]!),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.account_circle,
                  size: 60,
                  color: Colors.white,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.end, // ⬅️ teks rata kanan
                    children: [
                      Text(
                        item["mataKuliah"]!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right, // ⬅️ teks rata kanan
                      ),
                      SizedBox(height: 8),
                      Text(
                        item["waktu"]!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      Text(
                        item["ruang"]!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 12),
                      Text(
                        item["dosen"]!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
