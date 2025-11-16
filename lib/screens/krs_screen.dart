import 'package:flutter/material.dart';
import 'package:siakad_ft/core/utils/helpers.dart';
import '../services/krs_service.dart';
import '../models/krs_model.dart';

class KRSScreen extends StatefulWidget {
  const KRSScreen({Key? key}) : super(key: key);

  @override
  State<KRSScreen> createState() => _KRSScreenState();
}

class _KRSScreenState extends State<KRSScreen> {
  bool isLoading = true;
  List<KRSModel> krsList = [];
  String? token;
  int? userId;

  // Data mata kuliah yang tersedia untuk ditambahkan
  final List<Map<String, dynamic>> availableCourses = [
    {
      'id': 1,
      'kode': 'IF101',
      'nama': 'Pengantar Teknologi Informasi',
      'sks': 3,
      'lecturer': 'Dr. Andi',
    },
    {
      'id': 2,
      'kode': 'IF102',
      'nama': 'Algoritma & Pemrograman I',
      'sks': 4,
      'lecturer': 'Dr. Budi',
    },
    {
      'id': 3,
      'kode': 'IF103',
      'nama': 'Matematika Dasar',
      'sks': 3,
      'lecturer': 'Dr. Wati',
    },
    {
      'id': 4,
      'kode': 'IF104',
      'nama': 'Bahasa Indonesia',
      'sks': 2,
      'lecturer': 'Dr. Rina',
    },
    {
      'id': 5,
      'kode': 'IF201',
      'nama': 'Struktur Data',
      'sks': 4,
      'lecturer': 'Dr. Budi',
    },
    {
      'id': 6,
      'kode': 'IF202',
      'nama': 'Basis Data I',
      'sks': 3,
      'lecturer': 'Dr. Andi',
    },
    {
      'id': 7,
      'kode': 'IF203',
      'nama': 'Matematika Diskrit',
      'sks': 3,
      'lecturer': 'Dr. Dewi',
    },
    {
      'id': 8,
      'kode': 'IF204',
      'nama': 'Pancasila',
      'sks': 2,
      'lecturer': 'Dr. Rina',
    },
    {
      'id': 9,
      'kode': 'IF301',
      'nama': 'Basis Data II',
      'sks': 3,
      'lecturer': 'Dr. Andi',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      token = await Prefs.getToken();
      userId = await Prefs.getUserId();

      print("=== DEBUG KRS SCREEN ===");
      print("User ID: $userId");
      print("Token: $token");
      print("========================");

      if (token != null && userId != null) {
        await _fetchKRSData();
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

  Future<void> _fetchKRSData() async {
    try {
      setState(() {
        isLoading = true;
      });

      final data = await KRSService.getKRSByUser(userId!, token!);
      print("Dataaa $data");

      setState(() {
        krsList = data;
        isLoading = false;
      });

      print("=== KRS Data Debug ===");
      print("KRS List length: ${krsList.length}");
      if (krsList.isNotEmpty) {
        print("First KRS ID: ${krsList.first.id}");
        print("Details count: ${krsList.first.details?.length ?? 0}");
        if (krsList.first.details != null &&
            krsList.first.details!.isNotEmpty) {
          print("First detail: ${krsList.first.details!.first.toJson()}");
          print(
              "First detail course: ${krsList.first.details!.first.course?.courseName}");
        }
      }
      print("======================");
    } catch (e) {
      print("Error fetching KRS: $e");
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data KRS: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  int get totalSKS {
    if (krsList.isEmpty) return 0;
    final activeKRS = krsList.first;
    if (activeKRS.details == null) return 0;
    return activeKRS.details!
        .fold<int>(0, (sum, detail) => sum + (detail.course?.sks ?? 0));
  }

  List<KRSDetailModel> get selectedDetails {
    if (krsList.isEmpty) return [];
    return krsList.first.details ?? [];
  }

  // Mendapatkan course IDs yang sudah terdaftar
  Set<int> get registeredCourseIds {
    return selectedDetails
        .where((detail) => detail.courseId != null)
        .map((detail) => detail.courseId!)
        .toSet();
  }

  void _showAddCourseDialog() {
    String? selectedCourseId;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            // Filter courses yang belum terdaftar
            final availableToAdd = availableCourses
                .where((course) => !registeredCourseIds.contains(course['id']))
                .toList();

            return AlertDialog(
              title: const Text(
                'Tambah Mata Kuliah',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: availableToAdd.isEmpty
                  ? const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline,
                            size: 48, color: Colors.orange),
                        SizedBox(height: 16),
                        Text(
                          'Semua mata kuliah sudah terdaftar',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pilih Mata Kuliah',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedCourseId,
                                isExpanded: true,
                                hint: const Text('Pilih Mata Kuliah'),
                                items: availableToAdd.map((course) {
                                  return DropdownMenuItem<String>(
                                    value: course['id'].toString(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${course['kode']} - ${course['nama']}',
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                        Text(
                                          '${course['lecturer']} • ${course['sks']} SKS',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setStateDialog(() {
                                    selectedCourseId = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Batal'),
                ),
                if (availableToAdd.isNotEmpty)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25A4DB),
                    ),
                    onPressed: selectedCourseId != null
                        ? () async {
                            await _addCourse(selectedCourseId!);
                          }
                        : null,
                    child: const Text(
                      'Tambah',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _addCourse(String courseIdStr) async {
    final courseId = int.parse(courseIdStr);
    final course = availableCourses.firstWhere(
      (c) => c['id'] == courseId,
    );

    Navigator.pop(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Jika belum ada KRS, buat KRS baru
      if (krsList.isEmpty) {
        final newPayload = {
          'user_id': userId,
          'semester_id': 7,
          'finalized': false,
          'courses': [
            {'course_id': courseId}
          ],
        };

        final success = await KRSService.createKRS(newPayload, token!);

        if (mounted) Navigator.pop(context);

        if (success) {
          await _fetchKRSData();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Berhasil menambahkan ${course['nama']}'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal membuat KRS'),
              backgroundColor: Colors.red,
            ),
          );
        }

        return;
      }

      // Jika KRS sudah ada → cukup add detail
      final krsId = krsList.first.id;

      final payload = {
        'course_id': courseId,
      };

      final success = await KRSService.addCourseToKRS(krsId!, payload, token!);

      if (mounted) Navigator.pop(context);

      if (success) {
        await _fetchKRSData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Berhasil menambahkan ${course['nama']}'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menambahkan mata kuliah'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteDetail(KRSDetailModel detail) async {
    print(">>> _deleteDetail DIPANGGIL");

    final courseName = detail.course?.courseName ?? 'Mata kuliah';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Mata Kuliah'),
          content: Text('Apakah Anda yakin ingin menghapus "$courseName"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
    print(">>> confirmed = $confirmed");

    if (confirmed == true && detail.id != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final success = await KRSService.deleteKRS(
        detail.krsId!, // ID KRS utama
        detail.id!, // ID detail course yg mau dihapus
        token!,
      );

      if (mounted) Navigator.pop(context);

      if (success) {
        await _fetchKRSData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Berhasil menghapus $courseName'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menghapus mata kuliah'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showKartuUTS() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Kartu UTS'),
          content: const Text(
              'Fitur Kartu UTS akan menampilkan jadwal Ujian Tengah Semester Anda.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void _showKartuUAS() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Kartu UAS'),
          content: const Text(
              'Fitur Kartu UAS akan menampilkan jadwal Ujian Akhir Semester Anda.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

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
              onRefresh: _fetchKRSData,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card semester aktif
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF25A4DB), Color(0xFFECC116)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "T.A. 2025/2026 - Ganjil",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Semester 7",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "Aktif",
                                  style: TextStyle(
                                    color: Color(0xFF25A4DB),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "$totalSKS SKS",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "SKS semester ini",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tombol aksi
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _showAddCourseDialog,
                            icon: const Icon(Icons.add, size: 20),
                            label: const Text('Tambah MK'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF25A4DB),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _showKartuUTS,
                            icon: const Icon(Icons.description_outlined,
                                size: 20),
                            label: const Text('Kartu UTS'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF295690),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: Color(0xFF295690)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _showKartuUAS,
                            icon:
                                const Icon(Icons.assignment_outlined, size: 20),
                            label: const Text('Kartu UAS'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF295690),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: Color(0xFF295690)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Mata Kuliah Terdaftar",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${selectedDetails.length} mata kuliah",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // List mata kuliah
                    Expanded(
                      child: selectedDetails.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.school_outlined,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "Belum ada mata kuliah",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Tambahkan mata kuliah dengan tombol di atas",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[500],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: selectedDetails.length,
                              itemBuilder: (context, index) {
                                final detail = selectedDetails[index];
                                return buildDetailItem(context, detail, index);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildDetailItem(
    BuildContext context,
    KRSDetailModel detail,
    int index,
  ) {
    final course = detail.course;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF25A4DB).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        course?.courseCode ?? '-',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF25A4DB),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      course?.courseName ?? '-',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    if (course?.lecturer != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              course!.lecturer!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${detail.course?.sks ?? 0} SKS",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    onPressed: () => _deleteDetail(detail),
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red,
                    iconSize: 22,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (index != selectedDetails.length - 1)
          Divider(
            color: Colors.grey[300],
            thickness: 1,
            height: 16,
          ),
      ],
    );
  }
}
