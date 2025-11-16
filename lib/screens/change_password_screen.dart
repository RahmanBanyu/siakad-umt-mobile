import 'package:flutter/material.dart';
import 'package:siakad_ft/core/utils/helpers.dart';
import 'package:siakad_ft/services/auth_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? token; // token user

  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isLoading = false;

  void _handleChangePassword() async {
    token = await Prefs.getToken();
    final oldPass = _oldPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();
    final confirmPass = _confirmPasswordController.text.trim();
    print("Token: $token");
    print("Old password: $oldPass, New password: $newPass");

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Semua field wajib diisi")));
      return;
    }

    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Password baru tidak cocok")));
      return;
    }

    setState(() => _isLoading = true);

    final result = await AuthService.resetPassword(
      token!,
      oldPass,
      newPass,
    );

    setState(() => _isLoading = false);

    if (result["success"] == true) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result["message"])));
      Navigator.pop(context); // kembali ke halaman sebelumnya
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result["message"])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ubah Password",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPasswordField(
              controller: _oldPasswordController,
              label: "Password Lama",
              isVisible: _oldPasswordVisible,
              onToggle: () {
                setState(() {
                  _oldPasswordVisible = !_oldPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              controller: _newPasswordController,
              label: "Password Baru",
              isVisible: _newPasswordVisible,
              onToggle: () {
                setState(() {
                  _newPasswordVisible = !_newPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              controller: _confirmPasswordController,
              label: "Ulangi Password",
              isVisible: _confirmPasswordVisible,
              onToggle: () {
                setState(() {
                  _confirmPasswordVisible = !_confirmPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleChangePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA726),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Simpan",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: onToggle,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
