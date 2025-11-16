import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:siakad_ft/core/utils/helpers.dart';
import 'package:siakad_ft/services/tugas_akhir.dart';
import 'package:siakad_ft/models/tugas_akhir.dart';

class KPScreen extends StatefulWidget {
  const KPScreen({Key? key}) : super(key: key);

  @override
  State<KPScreen> createState() => _KPScreenState();
}

class _KPScreenState extends State<KPScreen> {
  bool isLoading = true;
  String? token;
  int? userId;
  TugasAkhir? kpData;

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nimController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController judulController = TextEditingController();
  final TextEditingController tempatController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    nimController.dispose();
    namaController.dispose();
    judulController.dispose();
    tempatController.dispose();
    unitController.dispose();
    alamatController.dispose();
    emailController.dispose();
    teleponController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      token = await Prefs.getToken();
      userId = await Prefs.getUserId();

      // Load data mahasiswa dari preferences
      final nim = await Prefs.getNim();
      final nama = await Prefs.getName();

      nimController.text = nim ?? '';
      namaController.text = nama ?? '';

      print("=== DEBUG KP SCREEN ===");
      print("User ID: $userId");
      print("Token: $token");
      print("NIM: $nim");
      print("========================");

      if (token != null && userId != null) {
        await _fetchKPData();
      } else {
        setState(() {
          isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Session berakhir. Silakan login kembali.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      print("Error loading user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchKPData() async {
    try {
      setState(() {
        isLoading = true;
      });

      final List<TugasAkhir> dataList =
          await TugasAkhirService.getByCategory('kp', token!);

      // Filter data berdasarkan user_id yang sedang login
      final userKPList = dataList.where((ta) => ta.userId == userId).toList();

      setState(() {
        if (userKPList.isNotEmpty) {
          kpData = userKPList.first;
        } else {
          kpData = null;
        }
        isLoading = false;
      });

      print("=== KP Data Debug ===");
      print("KP Data found: ${kpData != null}");
      if (kpData != null) {
        print("KP ID: ${kpData!.id}");
        print("Judul: ${kpData!.title}");
      }
      print("=====================");
    } catch (e) {
      print("Error fetching KP data: $e");
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data KP: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _submitPengajuan() async {
    if (_formKey.currentState!.validate()) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Konfirmasi Pengajuan'),
            content: const Text(
                'Apakah Anda yakin ingin mengajukan judul Kerja Praktek ini?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25A4DB),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text(
                  'Ya, Ajukan',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );

      if (confirmed == true) {
        // Show loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        final payload = {
          'user_id': userId,
          'category': 'kp',
          'student_name': namaController.text,
          'student_nim': nimController.text,
          'title': judulController.text,
          'research_place': tempatController.text,
          'unit': unitController.text,
          'address': alamatController.text,
          'company_email': emailController.text,
          'company_phone': teleponController.text,
        };

        final success = await TugasAkhirService.createTA(payload, token!);

        if (mounted) Navigator.pop(context); // Close loading

        if (success) {
          await _fetchKPData(); // Refresh data

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Pengajuan berhasil dikirim!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Gagal mengirim pengajuan. Silakan coba lagi.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchKPData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: kpData != null
                    ? _buildDetailView() // Ada data → tampilkan detail
                    : _buildFormView(), // Tidak ada data → tampilkan form
              ),
            ),
    );
  }

  // View ketika SUDAH ADA DATA
  Widget _buildDetailView() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Header Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF25A4DB), Color(0xFF1E88C7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Kerja Praktek",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'SEDANG DIAJUKAN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content Section
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Detail Mahasiswa Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Data Mahasiswa',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildDetailRow('NIM', kpData?.studentNim ?? '-'),
                      const Divider(height: 24),
                      _buildDetailRow('Nama', kpData?.studentName ?? '-'),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Detail Penelitian Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detail Penelitian',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildDetailRow('Judul', kpData?.title ?? '-'),
                      const Divider(height: 24),
                      _buildDetailRow(
                          'Tempat Penelitian', kpData?.researchPlace ?? '-'),
                      const Divider(height: 24),
                      _buildDetailRow('Unit/Divisi', kpData?.unit ?? '-'),
                      const Divider(height: 24),
                      _buildDetailRow('Alamat', kpData?.address ?? '-'),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Kontak Perusahaan Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kontak Perusahaan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildDetailRow('Email', kpData?.companyEmail ?? '-'),
                      const Divider(height: 24),
                      _buildDetailRow('Telepon', kpData?.companyPhone ?? '-'),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Progress Section
                const Text(
                  'Status Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildProgressItem(
                        iconPath: 'assets/icons/bookmark_added.svg',
                        title: 'Pendaftaran Judul',
                        date: kpData?.createdAt?.substring(0, 10) ?? '-',
                        isActive: true,
                        isCompleted: true,
                      ),
                      _buildProgressItem(
                        iconPath: 'assets/icons/credit_score.svg',
                        title: 'Verifikasi Keuangan',
                        date: '-',
                        isActive: false,
                        isCompleted: false,
                      ),
                      _buildProgressItem(
                        iconPath: 'assets/icons/rule.svg',
                        title: 'Verifikasi Akademik',
                        date: '-',
                        isActive: false,
                        isCompleted: false,
                      ),
                      _buildProgressItem(
                        iconPath: 'assets/icons/account_child.svg',
                        title: 'Penentuan Pembimbing',
                        date: '-',
                        isActive: false,
                        isCompleted: false,
                      ),
                      _buildProgressItem(
                        iconPath: 'assets/icons/co_present.svg',
                        title: 'Bimbingan & Seminar',
                        date: '-',
                        isActive: false,
                        isCompleted: false,
                        isLast: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // View ketika BELUM ADA DATA (form pengajuan)
  Widget _buildFormView() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Header Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF25A4DB), Color(0xFF1E88C7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Kerja Praktek",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'BELUM MENGAJUKAN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Form Content
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Form Pengajuan Judul KP',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lengkapi formulir di bawah ini untuk mengajukan judul Kerja Praktek Anda',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    controller: nimController,
                    label: 'NIM',
                    enabled: false,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: namaController,
                    label: 'Nama Lengkap',
                    enabled: false,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: judulController,
                    label: 'Judul Penelitian',
                    hint: 'Masukkan judul penelitian Kerja Praktek',
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Judul penelitian harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: tempatController,
                    label: 'Tempat Penelitian',
                    hint: 'Nama perusahaan/instansi',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tempat penelitian harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: unitController,
                    label: 'Unit/Divisi',
                    hint: 'Contoh: IT Department, HRD, dll',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Unit/Divisi harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: alamatController,
                    label: 'Alamat Tempat Penelitian',
                    hint: 'Alamat lengkap perusahaan/instansi',
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Alamat harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: emailController,
                    label: 'Email Perusahaan',
                    hint: 'email@perusahaan.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email harus diisi';
                      }
                      if (!value.contains('@')) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: teleponController,
                    label: 'Nomor Telepon Perusahaan',
                    hint: '08xxxxxxxxxx',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nomor telepon harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _submitPengajuan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25A4DB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Ajukan Judul KP',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    bool enabled = true,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          enabled: enabled,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: enabled ? Colors.white : const Color(0xFFF5F7FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF25A4DB), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressItem({
    required String iconPath,
    required String title,
    required String date,
    required bool isActive,
    required bool isCompleted,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFF25A4DB).withOpacity(0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                iconPath,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  isCompleted ? const Color(0xFF25A4DB) : Colors.grey.shade400,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.black87 : Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive ? Colors.grey[600] : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCompleted ? const Color(0xFF25A4DB) : Colors.grey[300],
              size: 24,
            ),
          ],
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
            child: Container(
              height: 30,
              width: 2,
              color: Colors.grey.shade200,
            ),
          ),
      ],
    );
  }
}
