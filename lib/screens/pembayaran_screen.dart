import 'package:flutter/material.dart';
import 'package:siakad_ft/core/utils/helpers.dart';
import '../services/payment_service.dart';
import '../models/payment_model.dart';

class PembayaranScreen extends StatefulWidget {
  const PembayaranScreen({Key? key}) : super(key: key);

  @override
  State<PembayaranScreen> createState() => _PembayaranScreenState();
}

class _PembayaranScreenState extends State<PembayaranScreen> {
  List<PaymentModel> _pembayaran = [];
  bool _isLoading = true;
  int? _userId;
  String? token;

  @override
  void initState() {
    super.initState();
    _loadUserAndPayments();
  }

  Future<void> _loadUserAndPayments() async {
    _userId = await Prefs.getUserId();
    token = await Prefs.getToken();
    if (_userId != null && token != null) {
      try {
        final payments =
            await PaymentService.getPaymentsByUser(_userId!, token!);
        setState(() {
          _pembayaran = payments;
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memuat pembayaran: $e")),
        );
      }
    }
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pembayaran.isEmpty
              ? const Center(child: Text("Belum ada data pembayaran"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _pembayaran.length,
                  itemBuilder: (context, index) {
                    final item = _pembayaran[index];

                    // Hitung sisa & terbayar
                    final terbayar = item.paid ? item.amount : 0;
                    final sisa = item.amount - terbayar;
                    final persentase =
                        ((terbayar / item.amount) * 100).toStringAsFixed(0);

                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "/pembayaran_detail",
                          arguments: item,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF150C90), Color(0xFFEFB1E2)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.description,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // penting untuk teks panjang
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "$persentase %",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Rp. ${item.amount.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Terbayar: ${terbayar.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  "Sisa: ${sisa.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
