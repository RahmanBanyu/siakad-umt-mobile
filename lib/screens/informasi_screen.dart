import 'package:flutter/material.dart';

class InformasiScreen extends StatelessWidget {
  final List<Map<String, String>> informasiList = [
    {
      "title": "Informasi 2",
      "date": "20 Oktober 2024",
    },
    {
      "title": "Informasi 1",
      "date": "15 Oktober 2024",
    },
  ];

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
      body: ListView.separated(
        itemCount: informasiList.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          color: Colors.grey,
        ),
        itemBuilder: (context, index) {
          final item = informasiList[index];
          return ListTile(
            title: Text(
              item['title']!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              item['date']!,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            trailing: const Icon(
              Icons.arrow_forward,
              size: 20,
              color: Colors.black87,
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                "/informasi_detail",
                arguments: item, // ⬅️ biar bisa kirim data ke detail
              );
            },
          );
        },
      ),
    );
  }
}
