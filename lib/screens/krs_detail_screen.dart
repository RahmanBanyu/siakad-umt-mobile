import 'package:flutter/material.dart';

class KRSDetailScreen extends StatelessWidget {
  const KRSDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> krsDetail = [
      {
        "kode": "TIF3401",
        "mataKuliah": "Mobile Programming",
        "sks": "3",
        "waktu": "Senin, 08:30 - 10:00 WIB",
        "ruang": "Ruang A12.7",
        "dosen": "Syepry Maulana Husain, S.Kom, MTI",
        "gradientStart": "#150C90",
        "gradientEnd": "#EFB1E2",
      },
      {
        "kode": "TIF3402",
        "mataKuliah": "Analisis dan Perancangan Sistem Informasi",
        "sks": "3",
        "waktu": "Selasa, 10:30 - 12:00 WIB",
        "ruang": "Ruang A12.5",
        "dosen": "Yani Sugiani, M.Kom",
        "gradientStart": "#E8AD0D",
        "gradientEnd": "#EFB1E2",
      },
      {
        "kode": "TIF3403",
        "mataKuliah": "Pemrograman Web Lanjut",
        "sks": "3",
        "waktu": "Rabu, 13:00 - 14:30 WIB",
        "ruang": "Lab Komputer 1",
        "dosen": "Dr. Ahmad Fauzi, M.Kom",
        "gradientStart": "#1E88E5",
        "gradientEnd": "#64B5F6",
      },
      {
        "kode": "TIF3404",
        "mataKuliah": "Keamanan Sistem Informasi",
        "sks": "3",
        "waktu": "Kamis, 08:00 - 09:30 WIB",
        "ruang": "Ruang A11.3",
        "dosen": "Budi Santoso, S.T., M.T.",
        "gradientStart": "#D32F2F",
        "gradientEnd": "#F48FB1",
      },
      {
        "kode": "TIF3405",
        "mataKuliah": "Kecerdasan Buatan",
        "sks": "3",
        "waktu": "Jumat, 10:00 - 11:30 WIB",
        "ruang": "Ruang A12.8",
        "dosen": "Prof. Dr. Sri Wahyuni, M.Sc",
        "gradientStart": "#7B1FA2",
        "gradientEnd": "#CE93D8",
      },
      {
        "kode": "TIF3406",
        "mataKuliah": "Cloud Computing",
        "sks": "3",
        "waktu": "Senin, 13:30 - 15:00 WIB",
        "ruang": "Lab Cloud",
        "dosen": "Dedi Hermawan, M.T.",
        "gradientStart": "#00897B",
        "gradientEnd": "#80CBC4",
      },
    ];

    int totalSKS =
        krsDetail.fold(0, (sum, item) => sum + int.parse(item["sks"]!));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Detail KRS",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: const Color(0xFF295690),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            color: const Color(0xFF295690),
            onPressed: () {
              Navigator.pushNamed(context, "/profile");
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Semester 7",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "T.A. 2025/2026 - Ganjil",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C6700),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "$totalSKS SKS",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "${krsDetail.length} Mata Kuliah",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // List mata kuliah
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: krsDetail.length,
              itemBuilder: (context, index) {
                final item = krsDetail[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        _hexToColor(item["gradientStart"]!),
                        _hexToColor(item["gradientEnd"]!),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _hexToColor(item["gradientStart"]!)
                            .withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon di kiri
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.book_outlined,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Info mata kuliah
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                item["mataKuliah"]!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${item['kode']} • ${item['sks']} SKS",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      item["waktu"]!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.room_outlined,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    item["ruang"]!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.person_outline,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      item["dosen"]!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xff')));
  }
}
