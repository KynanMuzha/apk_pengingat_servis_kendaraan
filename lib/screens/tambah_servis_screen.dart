import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../models/service_model.dart';
import '../models/kendaraan.dart';
import '../app_colors.dart';

class TambahServisScreen extends StatefulWidget {
  final Kendaraan kendaraan;

  const TambahServisScreen({super.key, required this.kendaraan});

  @override
  State<TambahServisScreen> createState() => _TambahServisScreenState();
}

class _TambahServisScreenState extends State<TambahServisScreen> {
  final namaController = TextEditingController();
  final biayaController = TextEditingController();
  final kmController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  // ================= SIMPAN =================
  void simpan() {
    if (namaController.text.isEmpty ||
        biayaController.text.isEmpty ||
        kmController.text.isEmpty) {
      return;
    }

    final box = Hive.box<ServiceModel>('serviceBox');

    final servis = ServiceModel(
      namaServis: namaController.text,
      tanggal: selectedDate,
      biaya: int.parse(biayaController.text),
      km: int.parse(kmController.text),
      kendaraanKey: widget.kendaraan.key as int,
    );

    box.add(servis);

    // 🔥 UPDATE kendaraan
    widget.kendaraan.servisTerakhir = selectedDate;
    widget.kendaraan.km = int.parse(kmController.text);
    widget.kendaraan.save();

    Navigator.pop(context);
  }

  // ================= DATE PICKER =================
  Future<void> pickDate() async {
    FocusScope.of(context).unfocus();

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobil = widget.kendaraan.jenis == "Mobil";

    return Scaffold(
      backgroundColor: AppColors.background,

      // ================= APPBAR =================
      appBar: AppBar(
        title: const Text("Tambah Servis"),
        centerTitle: true,
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // 🔥 HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.25),
                    AppColors.primary.withOpacity(0.05),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.kendaraan.nama,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Tambah riwayat servis kendaraan",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isMobil
                        ? Icons.directions_car
                        : Icons.motorcycle,
                    size: 40,
                    color: AppColors.primary,
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 FORM CARD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Column(
                children: [

                  _inputField(
                    controller: namaController,
                    hint: "Nama Servis",
                    icon: Icons.build,
                  ),

                  const SizedBox(height: 14),

                  _inputField(
                    controller: biayaController,
                    hint: "Biaya",
                    icon: Icons.attach_money,
                    isNumber: true,
                  ),

                  const SizedBox(height: 14),

                  _inputField(
                    controller: kmController,
                    hint: "Kilometer",
                    icon: Icons.speed,
                    isNumber: true,
                  ),

                  const SizedBox(height: 14),

                  // 🔥 DATE PICKER
                  GestureDetector(
                    onTap: pickDate,
                    child: _box(
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              color: AppColors.primary),
                          const SizedBox(width: 10),
                          Text(
                            DateFormat('dd MMM yyyy')
                                .format(selectedDate),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 🔥 BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: simpan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: const Text("Simpan"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= INPUT =================
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isNumber = false,
  }) {
    return _box(
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType:
                  isNumber ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _box({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}