import 'package:flutter/material.dart';
import '../services/khs_service.dart';
import '../models/khs_model.dart';
import 'package:siakad_ft/core/utils/helpers.dart';

class KHSScreen extends StatefulWidget {
  const KHSScreen({Key? key}) : super(key: key);

  @override
  State<KHSScreen> createState() => _KHSScreenState();
}

class _KHSScreenState extends State<KHSScreen> {
  bool isLoading = true;
  List<KHSModel> khsList = [];
  String? token;
  String selectedSemester = "Semua";

  // Data dummy untuk semester info
  final List<Map<String, dynamic>> semesterData = [
    {'semester': 'Semester 1', 'year': '2022/2023', 'term': 'Ganjil'},
    {'semester': 'Semester 2', 'year': '2022/2023', 'term': 'Genap'},
    {'semester': 'Semester 3', 'year': '2023/2024', 'term': 'Ganjil'},
    {'semester': 'Semester 4', 'year': '2023/2024', 'term': 'Genap'},
    {'semester': 'Semester 5', 'year': '2024/2025', 'term': 'Ganjil'},
    {'semester': 'Semester 6', 'year': '2024/2025', 'term': 'Genap'},
    {'semester': 'Semester 7', 'year': '2025/2026', 'term': 'Ganjil'},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      token = await Prefs.getToken();

      print("=== DEBUG KHS SCREEN ===");
      print("Token: $token");
      print("========================");

      if (token != null) {
        await _fetchKHSData();
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
      print("Error loading data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchKHSData() async {
    try {
      setState(() {
        isLoading = true;
      });

      final data = await KHSService.getKHS(token!);

      setState(() {
        khsList = data;
        isLoading = false;
      });

      print("KHS Data loaded: ${khsList.length} items");
      for (var khs in khsList) {
        print(
            "Semester ${khs.semesterId}: ${khs.details?.length ?? 0} courses");
      }
    } catch (e) {
      print("Error fetching KHS: $e");
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data KHS: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

// List semester untuk dropdown
  List<String> get semesterOptions {
    List<String> options = ["Semua"];
    Set<String> semesters = {};
    for (var khs in khsList) {
      if (khs.semesterId != null) {
        String semesterName = "Semester ${khs.semesterId}";
        semesters.add(semesterName);
      }
    }
    options.addAll(semesters.toList()..sort());
    return options;
  }

// Filter courses berdasarkan semester
  List<KRSDetailModel> get filteredCourses {
    if (selectedSemester == "Semua") {
      // Gabungkan semua details dari semua semester
      List<KRSDetailModel> allDetails = [];
      for (var khs in khsList) {
        if (khs.details != null) {
          allDetails.addAll(khs.details!);
        }
      }
      return allDetails;
    } else {
      int semesterNum =
          int.tryParse(selectedSemester.replaceAll("Semester ", "")) ?? 0;
      var khs = khsList.firstWhere(
        (k) => k.semesterId == semesterNum,
        orElse: () => KHSModel(),
      );
      return khs.details ?? [];
    }
  }

// Hitung total IPK
  double get totalIPK {
    if (khsList.isEmpty) return 0.0;
    final validKHS =
        khsList.where((khs) => khs.gpa != null && khs.gpa! > 0).toList();
    if (validKHS.isEmpty) return 0.0;
    final total =
        validKHS.fold<double>(0.0, (sum, khs) => sum + (khs.gpa ?? 0.0));
    return total / validKHS.length;
  }

// Hitung total mata kuliah
  int get totalMataKuliah {
    int total = 0;
    for (var khs in khsList) {
      total += khs.details?.length ?? 0;
    }
    return total;
  }

// Cari semester dari KRSDetail
  String _getSemesterName(KRSDetailModel detail) {
    for (var khs in khsList) {
      if (khs.details != null && khs.details!.any((d) => d.id == detail.id)) {
        return "Semester ${khs.semesterId}";
      }
    }
    return "";
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
              onRefresh: _fetchKHSData,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card statistik
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF25A4DB), Color(0xFFECC116)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Total Mata Kuliah",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "$totalMataKuliah",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 90),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "IPK",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                totalIPK.toStringAsFixed(2),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Filter section
                    if (semesterOptions.length > 1)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedSemester,
                            isExpanded: true,
                            hint: const Text("Pilih Semester"),
                            icon: const Icon(Icons.arrow_drop_down),
                            items: semesterOptions.map((String semester) {
                              return DropdownMenuItem<String>(
                                value: semester,
                                child: Text(
                                  semester,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedSemester = newValue!;
                              });
                            },
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Daftar Mata Kuliah",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${filteredCourses.length} mata kuliah",
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
                      child: filteredCourses.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "Tidak ada data mata kuliah",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Tarik ke bawah untuk refresh",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredCourses.length,
                              itemBuilder: (context, index) {
                                final course = filteredCourses[index];
                                return buildCourseItem(
                                  context,
                                  course.course?.courseCode ?? '-',
                                  course.course?.courseName ?? '-',
                                  course.course?.sks ?? 0,
                                  course.grade ?? '-',
                                  selectedSemester == "Semua"
                                      ? _getSemesterName(course)
                                      : "",
                                  index,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildCourseItem(
    BuildContext context,
    String kode,
    String nama,
    int sks,
    String nilai,
    String semester,
    int index,
  ) {
    Color nilaiColor;
    if (nilai == 'A') {
      nilaiColor = const Color(0xFF2C6700);
    } else if (nilai.startsWith('A')) {
      nilaiColor = const Color(0xFF4CAF50);
    } else if (nilai.startsWith('B')) {
      nilaiColor = const Color(0xFF1565C0);
    } else if (nilai == '-') {
      nilaiColor = Colors.grey;
    } else {
      nilaiColor = const Color(0xFFF57C00);
    }

    return Column(
      children: [
        InkWell(
          onTap: () {
            // Detail mata kuliah jika diperlukan
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kode,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        nama,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "$sks SKS",
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // if (semester.isNotEmpty) ...[
                          //   const SizedBox(width: 8),
                          //   Text(
                          //     semester,
                          //     style: TextStyle(
                          //       fontSize: 11,
                          //       color: Colors.grey[600],
                          //     ),
                          //   ),
                          // ],
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: nilaiColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: nilaiColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    nilai,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: nilaiColor,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (index != filteredCourses.length - 1)
          Divider(
            color: Colors.grey[300],
            thickness: 1,
            height: 1,
          ),
      ],
    );
  }
}
