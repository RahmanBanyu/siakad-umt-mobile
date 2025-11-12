import 'package:flutter/material.dart';

class TugasAkhirScreen extends StatelessWidget {
  const TugasAkhirScreen({super.key});

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
        title: const Text(
          'SIAKAD FT',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/kp");
              },
              child: Container(
                width: double.infinity,
                height: 140,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage("assets/images/blue-group.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(20),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/skripsi");
              },
              child: Container(
                width: double.infinity,
                height: 140,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage("assets/images/yellow-group.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
