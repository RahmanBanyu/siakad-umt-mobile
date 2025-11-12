import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
      body: Stack(
        children: [
          // Background image
          Positioned(
            bottom: -80,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/gedung.png',
              fit: BoxFit.contain,
            ),
          ),
          // Menu buttons (kanan layar)
          Positioned(
            top: 20,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildMenuButton('Informasi', () {
                  Navigator.pushNamed(context, "/informasi");
                }),
                const SizedBox(height: 12),
                _buildMenuButton('Kartu Rencana Studi', () {
                  Navigator.pushNamed(context, "/krs");
                }),
                const SizedBox(height: 12),
                _buildMenuButton('Hasil Studi', () {
                  Navigator.pushNamed(context, "/khs");
                }),
                const SizedBox(height: 12),
                _buildMenuButton('Pembayaran', () {
                  Navigator.pushNamed(context, "/pembayaran");
                }),
                const SizedBox(height: 12),
                _buildMenuButton('Tugas Akhir', () {
                  Navigator.pushNamed(context, "/tugasakhir");
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(String text, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.only(right: 0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE6A935),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              bottomLeft: Radius.circular(25),
            ),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
