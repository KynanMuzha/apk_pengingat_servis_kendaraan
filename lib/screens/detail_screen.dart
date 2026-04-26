import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/kendaraan.dart';
import '../models/service_model.dart';
import '../app_colors.dart';
import 'tambah_servis_screen.dart';

class DetailScreen extends StatelessWidget {
  final Kendaraan kendaraan;

  const DetailScreen({super.key, required this.kendaraan});

  @override
  Widget build(BuildContext context) {
    final nextService = kendaraan.servisBerikutnya;
    final difference = nextService.difference(DateTime.now()).inDays;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      // ================= APPBAR =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Detail Kendaraan",
          style: TextStyle(color: Colors.black),
        ),
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔥 HEADER BARU (LEBIH PREMIUM)
            _header(),

            const SizedBox(height: 16),

            _statusCard(difference),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _infoCard(
                    title: "KILOMETER",
                    value: "${kendaraan.km}",
                    unit: "KM",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _infoCard(
                    title: "SERVIS",
                    value: _formatShortDate(kendaraan.servisTerakhir),
                    unit: "",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              "Riwayat Servis",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 12),

            ValueListenableBuilder<Box<ServiceModel>>(
              valueListenable:
                  Hive.box<ServiceModel>('serviceBox').listenable(),
              builder: (context, box, _) {

                final riwayat = box.values
                    .where((e) => e.kendaraanKey == kendaraan.key)
                    .toList()
                  ..sort((a, b) => b.tanggal.compareTo(a.tanggal));

                if (riwayat.isEmpty) {
                  return _empty();
                }

                return Column(
                  children: riwayat.map((e) {
                    return _historyItem(
                      e.namaServis,
                      "Rp ${e.biaya}",
                      _formatDate(e.tanggal),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),

      // ================= BUTTON =================
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        TambahServisScreen(kendaraan: kendaraan),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: const Text("Tambah Servis"),
            ),
          ),
        ),
      ),
    );
  }

  // ================= HEADER PREMIUM =================
  Widget _header() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.25),
            AppColors.primary.withOpacity(0.05),
          ],
        ),
      ),
      child: Stack(
        children: [

          // BULAT BACKGROUND
          Positioned(
            right: -40,
            top: -20,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // 🔥 NAMA BESAR
                Text(
                  kendaraan.nama,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 16),

                // ICON
                Row(
                  children: [
                    Icon(Icons.directions_car,
                        size: 50, color: AppColors.primary),
                    const SizedBox(width: 16),
                    Container(
                      width: 2,
                      height: 40,
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.motorcycle,
                        size: 50, color: AppColors.primary),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= STATUS =================
  Widget _statusCard(int diff) {
    Color color;
    String text;

    if (diff < 0) {
      color = Colors.red;
      text = "Terlambat ${diff.abs()} hari";
    } else if (diff <= 3) {
      color = Colors.red;
      text = "$diff hari lagi servis";
    } else if (diff <= 7) {
      color = Colors.orange;
      text = "$diff hari lagi";
    } else {
      color = AppColors.primary;
      text = "$diff hari lagi";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.info, color: color),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ================= EMPTY =================
  Widget _empty() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(Icons.build_circle_outlined,
              size: 40,
              color: AppColors.primary.withOpacity(0.5)),
          const SizedBox(height: 10),
          const Text("Belum ada riwayat servis"),
          const SizedBox(height: 4),
          const Text(
            "Tambahkan servis pertama",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ================= ITEM =================
  Widget _historyItem(String title, String price, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                const SizedBox(height: 4),
                Text(date,
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Text(price, style: const TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }

  // ================= FORMAT =================
  String _formatDate(DateTime date) {
    const bulan = [
      "Jan","Feb","Mar","Apr","Mei","Jun",
      "Jul","Agu","Sep","Okt","Nov","Des"
    ];
    return "${date.day} ${bulan[date.month - 1]} ${date.year}";
  }

  String _formatShortDate(DateTime date) {
    const bulan = [
      "Jan","Feb","Mar","Apr","Mei","Jun",
      "Jul","Agu","Sep","Okt","Nov","Des"
    ];
    return "${date.day} ${bulan[date.month - 1]}";
  }

  // ================= INFO CARD =================
  Widget _infoCard({
    required String title,
    required String value,
    required String unit,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(value,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              if (unit.isNotEmpty)
                Text(" $unit",
                    style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}