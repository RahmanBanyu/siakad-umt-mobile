import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lupa Password"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // kasih padding biar gak dempet
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Masukan email yang anda daftarkan pada aplikasi ini, "
              "sistem akan mengirimkan link form password baru.",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            SizedBox(height: 30), // jarak ke input email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: UnderlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 40), // jarak ke tombol
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // aksi kirim email reset password
                },
                child: Text(
                  "Kirim",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
