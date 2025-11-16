import 'package:flutter/material.dart';
import 'package:siakad_ft/core/utils/helpers.dart';
import 'package:siakad_ft/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _isLoading = false;

  final TextEditingController _emailController =
      TextEditingController(text: "");
  final TextEditingController _passwordController =
      TextEditingController(text: "");

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan password wajib diisi")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final response = await AuthService.login(email, pass);

    setState(() => _isLoading = false);

    if (response["success"] == true) {
      final user = response["user"];

      await Prefs.saveToken(response["token"]);

      if (user != null && user.id != null) {
        await Prefs.saveUserId(user.id);
      }

      if (user != null && user.nim != null) {
        await Prefs.setNim(user.nim);
        print("NIM DISIMPAN: ${user.nim}");
      }

      if (user != null && user.name != null) {
        await Prefs.setName(user.name);
        print("NAMA DISIMPAN: ${user.name}");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Berhasil")),
      );

      Navigator.pushReplacementNamed(context, "/home");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response["message"] ?? "Login gagal")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                // Logo
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'SIAKAD FTUMT',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Sistem Akademik',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                // Sign In Title
                const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Hi there! Nice to see you again.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(height: 32),
                // Username Field
                const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'example@email.com',
                    hintStyle: TextStyle(color: Colors.black38),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Password Field
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  autofillHints: const [AutofillHints.password],
                  decoration: InputDecoration(
                    hintText: '••••••••••',
                    hintStyle: const TextStyle(
                      color: Colors.black38,
                      fontSize: 20,
                      letterSpacing: 2,
                    ),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.black26,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA726),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Bottom Links
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Belum punya akun? ',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/register");
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Daftar',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFFFFA726),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/forgot_password");
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Lupa Password',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFFFA726),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
