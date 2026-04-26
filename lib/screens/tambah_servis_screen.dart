import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/service_model.dart';
import '../models/kendaraan.dart';
import '../app_colors.dart';
import 'package:intl/intl.dart';

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

  Future<void> pickDate() async {
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Tambah Servis"),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            _field(namaController, "Nama Servis"),
            const SizedBox(height: 10),

            _field(biayaController, "Biaya", isNumber: true),
            const SizedBox(height: 10),

            _field(kmController, "Kilometer", isNumber: true),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: pickDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 10),
                    Text(DateFormat('dd MMM yyyy').format(selectedDate)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: simpan,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String hint,
      {bool isNumber = false}) {
    return TextField(
      controller: c,
      keyboardType: isNumber ? TextInputType.number : null,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}