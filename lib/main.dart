import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/krs_screen.dart';
import 'screens/krs_detail_screen.dart';
import 'screens/khs_screen.dart';
import 'screens/khs_detail_screen.dart';
import 'screens/skripsi_screen.dart';
import 'screens/kp_screen.dart';
import 'screens/informasi_screen.dart';
import 'screens/informasi_detail_screen.dart';
import 'screens/tugasakhir_screen.dart';
import 'screens/pembayaran_screen.dart';
import 'screens/pembayaran_detail_screen.dart';

void main() {
  runApp(SiakadApp());
}

class SiakadApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SIAKAD FT",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/login",
      routes: {
        "/login": (context) => LoginScreen(),
        "/register": (context) => RegisterScreen(),
        "/forgot_password": (context) => ForgotPasswordScreen(),
        "/change_password": (context) => ChangePasswordScreen(),
        "/home": (context) => HomeScreen(),
        "/profile": (context) => ProfileScreen(),
        "/krs": (context) => KRSScreen(),
        "/krs_detail": (context) => KRSDetailScreen(),
        "/khs": (context) => KHSScreen(),
        "/khs_detail": (context) => KHSDetailScreen(),
        "/skripsi": (context) => SkripsiScreen(),
        "/kp": (context) => KPScreen(),
        "/informasi": (context) => InformasiScreen(),
        "/informasi_detail": (context) => InformasiDetailScreen(),
        "/tugasakhir": (context) => TugasAkhirScreen(),
        "/pembayaran": (context) => PembayaranScreen(),
        "/pembayaran_detail": (context) => PembayaranDetailScreen(),
      },
    );
  }
}
