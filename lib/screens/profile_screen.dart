import 'package:flutter/material.dart';
import 'package:siakad_ft/core/utils/helpers.dart';
import 'package:siakad_ft/models/user_model.dart';
import 'package:siakad_ft/services/auth_service.dart';
import 'package:siakad_ft/services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? user;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadMe();
  }

  Future<void> loadMe() async {
    final token = await Prefs.getToken(); // ambil token dari penyimpanan
    if (token == null) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Token tidak ditemukan, silahkan login ulang")),
      );
      return;
    }
    final res = await UserService.me(token);
    print(token);

    if (res["success"]) {
      setState(() {
        user = res["user"];
        loading = false;
      });
    } else {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Gagal mengambil data user")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : buildProfile(),
    );
  }

  Widget buildProfile() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF091552),
            Color(0xFF4A5A7F),
            Color(0xFF8B8B6B),
            Color(0xFFE0B533),
            Color(0xFFFFC815),
          ],
          stops: [0.0, 0.3, 0.5, 0.7, 1.0],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 30),

              Icon(Icons.account_circle, size: 120, color: Colors.white),

              SizedBox(height: 16),
              Text(
                user?.name ?? "-",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 4),
              Text(
                user?.nim ?? "-",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),

              SizedBox(height: 30),

              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildInfoRow("Email", user?.email ?? "-"),
                    SizedBox(height: 16),
                    _buildInfoRow("Role", user?.role ?? "-"),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // change password
              Container(
                width: double.infinity,
                height: 54,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/change_password");
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 12),
                  ),
                  child: Text(
                    "Ubah Password",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // logout
              Container(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/login", (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF091552),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "LOGOUT",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.black38)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
