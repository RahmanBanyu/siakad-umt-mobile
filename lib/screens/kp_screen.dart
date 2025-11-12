import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KPScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/logo.png',
            width: 40,
            height: 40,
          ),
        ),
        title: InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/home");
          },
          child: const Text(
            'SIAKAD FT',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            iconSize: 28,
            color: const Color(0xFF295690),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            iconSize: 30,
            color: const Color(0xFF295690),
            onPressed: () {
              Navigator.pushNamed(context, "/profile");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    // Gambar background utama
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/blue.png',
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Overlay riset di kanan atas
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/riset-blue.png',
                          height: 180,
                          fit: BoxFit.cover,
                          opacity: const AlwaysStoppedAnimation(
                              0.8), // agak transparan
                        ),
                      ),
                    ),

                    // Tulisan di atas semua
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Kerja Praktek",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text.rich(
                            TextSpan(
                              text: "Status Progres: ",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 14),
                              children: [
                                TextSpan(
                                  text: "DAFTAR JUDUL",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildInfoSection('JUDUL KERJA PRAKTEK',
                  'Analisa dan Perancangan Aplikasi Sistem Akademik Berbasis Mobile'),
              const SizedBox(height: 20),
              _buildInfoSection('TEMPAT PENELITIAN',
                  'Fakultas Teknik Universitas Muhammadiyah Tangerang'),
              const SizedBox(height: 20),
              _buildInfoSection('ALAMAT PENELITIAN',
                  'Jalan Perintis Kemerdekaan I Cikokol Tangerang'),
              const SizedBox(height: 20),
              _buildInfoSection(
                  'PEMBIMBING', 'Syepry Maulana Husain, S.Kom, MTI'),
              const SizedBox(height: 24),

              // === PROGRESS ITEM ===
              _buildProgressItem(
                iconPath: 'assets/icons/bookmark_added.svg',
                title: 'Pendaftaran Judul',
                date: '20-10-2024',
                isActive: true,
                isCompleted: true,
                isDoubleCheck: true,
              ),
              _buildProgressItem(
                iconPath: 'assets/icons/credit_score.svg',
                title: 'Verifikasi Keuangan',
                date: '20-10-2024',
                isActive: true,
                isCompleted: true,
              ),
              _buildProgressItem(
                iconPath: 'assets/icons/rule.svg',
                title: 'Verifikasi Akademik',
                date: '20-10-2024',
                isActive: false,
                isCompleted: false,
              ),
              _buildProgressItem(
                iconPath: 'assets/icons/account_child.svg',
                title: 'Penentuan Pembimbing',
                date: '20-10-2024',
                isActive: false,
                isCompleted: false,
              ),
              _buildProgressItem(
                iconPath: 'assets/icons/co_present.svg',
                title: 'Verifikasi Akademik',
                date: '20-10-2024',
                isActive: false,
                isCompleted: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[400],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressItem({
    required String iconPath,
    required String title,
    required String date,
    required bool isActive,
    required bool isCompleted,
    bool isDoubleCheck = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          // SVG ICON — dikecilkan dari 28 → 18
          SvgPicture.asset(
            iconPath,
            width: 18,
            height: 18,
            colorFilter: ColorFilter.mode(
              isActive ? Colors.green : Colors.grey.shade300,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 12), // sedikit diperkecil jaraknya

          // Text Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.black87 : Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 11,
                    color: isActive ? Colors.black54 : Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),

          // CHECK ICON — dikecilkan dari 24 → 20
          Icon(
            isCompleted
                ? (isDoubleCheck ? Icons.done_all : Icons.check)
                : Icons.check,
            color: isCompleted ? Colors.green : Colors.grey[300],
            size: 20,
          ),
        ],
      ),
    );
  }
}
