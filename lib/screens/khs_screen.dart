import 'package:flutter/material.dart';

class KHSScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onPressed: () {
              // Aksi notifikasi
            },
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card atas dengan gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF25A4DB), Color(0xFFECC116)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        "Total Mata Kuliah",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "112",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 90),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        "IPK",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "3.52",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            Text(
              "Semua Semester",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 16),

            // List semua semester
            Expanded(
              child: ListView(
                children: [
                  buildSemesterItem(context, "Semester 1", "Aktif", 38, true),
                  buildSemesterItem(context, "Semester 2", "Aktif", 3.62, true),
                  buildSemesterItem(context, "Semester 3", "Aktif", 3.38, true),
                  buildSemesterItem(context, "Semester 4", "Aktif", 3.76, true),
                  buildSemesterItem(context, "Semester 5", "Aktif", 3.56, true),
                  buildSemesterItem(
                      context, "Semester 6", "Cuti Kuliah", 0, false),
                  buildSemesterItem(context, "Semester 7", "Aktif", 0, true),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSemesterItem(BuildContext context, String semester, String status,
      double ipk, bool aktif) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, "/khs_detail");
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      semester,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      status,
                      style: TextStyle(
                        color: Color(0xFF2C6700),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Container(
                  width:
                      90, 
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                  alignment:
                      Alignment.center, 
                  decoration: BoxDecoration(
                    color: aktif
                        ? const Color(0xFFC7F9A2)
                        : const Color(0xFFF9AFA2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    ipk % 1 == 0 ? ipk.toInt().toString() : ipk.toString(),
                    textAlign: TextAlign.center, 
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C6700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          color: Colors.grey[300],
          thickness: 1,
        ),
      ],
    );
  }
}
