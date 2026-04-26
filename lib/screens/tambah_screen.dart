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

  bool get isEdit => widget.kendaraan != null;

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      final k = widget.kendaraan!;
      nameController.text = k.nama;
      kmController.text = k.km.toString();
      intervalController.text = k.interval.toString();
      selectedDate = k.servisTerakhir;
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

  // ================= DATE PICKER =================
  Future<void> pickDate() async {
    FocusScope.of(context).unfocus();

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            useMaterial3: false,
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
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
      k.save();
    } else {
      final kendaraan = Kendaraan(
        nama: nameController.text,
        km: int.parse(kmController.text),
        interval: intervalType == "Hari"
            ? int.parse(intervalController.text)
            : int.parse(intervalController.text) * 30,
        servisTerakhir: selectedDate!,
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

      // ================= APPBAR =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
      ),

      // ================= BODY =================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _header(),

              const SizedBox(height: 30),

              label("NAMA KENDARAAN"),
              inputField(
                controller: nameController,
                hint: "Contoh: Honda Vario 160",
                icon: Icons.directions_car,
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
                    flex: 2,
                    child: inputField(
                      controller: intervalController,
                      hint: "Masukkan interval",
                      icon: Icons.refresh,
                      onChanged: (_) => calculateNextService(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
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
                            setState(() {
                              intervalType = value!;
                            });
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

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isValid ? simpan : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: Text(
                    isEdit ? "Simpan Perubahan" : "Simpan Kendaraan",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
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
              opacity: 0.1,
              child: Icon(
                Icons.directions_car,
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
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    isEdit ? "EDIT DATA" : "DATA BARU",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  isEdit ? "Edit Kendaraan" : "Detail Kendaraan",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isEdit
                      ? "Perbarui data kendaraan untuk memantau servis"
                      : "Tambahkan kendaraan untuk memantau servis",
                  style: const TextStyle(
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

  // ================= COMPONENT =================
  Widget label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
      ),
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