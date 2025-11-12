import 'package:flutter/material.dart';

class KRSScreen extends StatelessWidget {
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
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [Color(0xFF25A4DB), Color(0xFFECC116)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "T.A. 2024/2025",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Semester 7",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        child: Text("Aktif"),
                      ),
                      Text(
                        "22 SKS",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
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
                  buildSemesterItem(context, "Semester 1", "Aktif", 22, true),
                  buildSemesterItem(context, "Semester 2", "Aktif", 22, true),
                  buildSemesterItem(context, "Semester 3", "Aktif", 22, true),
                  buildSemesterItem(context, "Semester 4", "Aktif", 22, true),
                  buildSemesterItem(context, "Semester 5", "Aktif", 22, true),
                  buildSemesterItem(
                      context, "Semester 6", "Cuti Kuliah", 0, false),
                  buildSemesterItem(context, "Semester 7", "Aktif", 22, true),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSemesterItem(BuildContext context, String semester, String status,
      int sks, bool aktif) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, "/krs_detail");
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
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    color: aktif ? Color(0xFFC7F9A2) : Color(0xFFF9AFA2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    "$sks SKS",
                    style: TextStyle(
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
