import 'dart:math';
import 'package:flutter/material.dart';
import '../models/kendaraan.dart';
import '../app_colors.dart';
import 'package:intl/intl.dart';

class TambahScreen extends StatefulWidget {
  final Kendaraan? kendaraan;

  const TambahScreen({super.key, this.kendaraan});

  @override
  State<TambahScreen> createState() => _TambahScreenState();
}

class _TambahScreenState extends State<TambahScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController kmController = TextEditingController();
  final TextEditingController intervalController = TextEditingController();

  DateTime? selectedDate;
  String intervalType = "Hari";
  DateTime? nextService;

  String jenisKendaraan = "Mobil";

  bool get isEdit => widget.kendaraan != null;

  // 🔥 RANDOM CONTOH
  String get contohHint {
    final mobil = [
      "Toyota Avanza",
      "Honda Brio",
      "Toyota Innova",
      "Suzuki Ertiga"
    ];

    final motor = [
      "Honda Vario 160",
      "Yamaha NMAX",
      "Beat Street",
      "Aerox 155"
    ];

    final list = jenisKendaraan == "Mobil" ? mobil : motor;
    return list[Random().nextInt(list.length)];
  }

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      final k = widget.kendaraan!;
      nameController.text = k.nama;
      kmController.text = k.km.toString();
      intervalController.text = k.interval.toString();
      selectedDate = k.servisTerakhir;
      jenisKendaraan = k.jenis;

      calculateNextService();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    kmController.dispose();
    intervalController.dispose();
    super.dispose();
  }

  // ================= DATE =================
  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
      calculateNextService();
    }
  }

  // ================= HITUNG =================
  void calculateNextService() {
    if (selectedDate == null || intervalController.text.isEmpty) return;

    final interval = int.tryParse(intervalController.text);
    if (interval == null) return;

    setState(() {
      if (intervalType == "Hari") {
        nextService = selectedDate!.add(Duration(days: interval));
      } else {
        nextService = DateTime(
          selectedDate!.year,
          selectedDate!.month + interval,
          selectedDate!.day,
        );
      }
    });
  }

  // ================= SIMPAN =================
  void simpan() {
    if (!isValid) return;

    if (isEdit) {
      final k = widget.kendaraan!;
      k.nama = nameController.text;
      k.km = int.parse(kmController.text);
      k.interval = intervalType == "Hari"
          ? int.parse(intervalController.text)
          : int.parse(intervalController.text) * 30;
      k.servisTerakhir = selectedDate!;
      k.jenis = jenisKendaraan;

      k.save();
    } else {
      final kendaraan = Kendaraan(
        nama: nameController.text,
        km: int.parse(kmController.text),
        interval: intervalType == "Hari"
            ? int.parse(intervalController.text)
            : int.parse(intervalController.text) * 30,
        servisTerakhir: selectedDate!,
        jenis: jenisKendaraan,
      );

      Navigator.pop(context, kendaraan);
      return;
    }

    Navigator.pop(context);
  }

  bool get isValid =>
      nameController.text.isNotEmpty &&
      kmController.text.isNotEmpty &&
      intervalController.text.isNotEmpty &&
      selectedDate != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEdit ? "EDIT KENDARAAN" : "TAMBAH KENDARAAN",
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            _header(),

            const SizedBox(height: 25),

            label("JENIS KENDARAAN"),
            Row(
              children: [
                _jenisButton("Mobil", Icons.directions_car),
                const SizedBox(width: 10),
                _jenisButton("Motor", Icons.motorcycle),
              ],
            ),

            const SizedBox(height: 20),

            label("NAMA KENDARAAN"),
            inputField(
              controller: nameController,
              hint: "Contoh: $contohHint",
              icon: jenisKendaraan == "Mobil"
                  ? Icons.directions_car
                  : Icons.motorcycle,
            ),

            const SizedBox(height: 20),

            label("SERVIS TERAKHIR"),
            GestureDetector(
              onTap: pickDate,
              child: box(
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Text(
                      selectedDate == null
                          ? "Pilih tanggal"
                          : DateFormat('dd MMM yyyy').format(selectedDate!),
                    ),
                    const Spacer(),
                    const Icon(Icons.calendar_month),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            label("KILOMETER"),
            inputField(
              controller: kmController,
              hint: "0",
              icon: Icons.speed,
            ),

            const SizedBox(height: 20),

            label("INTERVAL SERVIS"),
            Row(
              children: [
                Expanded(
                  child: inputField(
                    controller: intervalController,
                    hint: "Masukkan interval",
                    icon: Icons.refresh,
                    onChanged: (_) => calculateNextService(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: box(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: intervalType,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: "Hari", child: Text("Hari")),
                          DropdownMenuItem(value: "Bulan", child: Text("Bulan")),
                        ],
                        onChanged: (value) {
                          setState(() => intervalType = value!);
                          calculateNextService();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (nextService != null)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.schedule, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Servis berikutnya: ${DateFormat('dd MMM yyyy').format(nextService!)}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: isValid ? simpan : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: Text(
                isEdit ? "Simpan Perubahan" : "Simpan Kendaraan",
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HEADER BAGUS =================
  Widget _header() {
    return SizedBox(
      height: 170,
      child: Stack(
        children: [

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.08),
                  AppColors.primary.withOpacity(0.02),
                ],
              ),
            ),
          ),

          Positioned(
            right: -40,
            top: -20,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            right: 10,
            top: 30,
            child: Opacity(
              opacity: 0.12,
              child: Icon(
                jenisKendaraan == "Mobil"
                    ? Icons.directions_car
                    : Icons.motorcycle,
                size: 120,
                color: AppColors.primary,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    jenisKendaraan,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  isEdit ? "Edit Kendaraan" : "Tambah Kendaraan",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Kelola kendaraan untuk memantau servis",
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _jenisButton(String jenis, IconData icon) {
    final selected = jenisKendaraan == jenis;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => jenisKendaraan = jenis),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : Colors.grey.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color:
                      selected ? AppColors.primary : Colors.grey),
              const SizedBox(width: 6),
              Text(
                jenis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color:
                      selected ? AppColors.primary : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              fontSize: 12)),
    );
  }

  Widget inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    Function(String)? onChanged,
  }) {
    return box(
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (val) {
                setState(() {});
                if (onChanged != null) onChanged(val);
              },
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

  Widget box({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.textSecondary.withOpacity(0.1),
        ),
      ),
      child: child,
    );
  }
}