import 'package:flutter/material.dart';
import '../models/kendaraan.dart';

class TambahScreen extends StatefulWidget {
  @override
  _TambahScreenState createState() => _TambahScreenState();
}

class _TambahScreenState extends State<TambahScreen> {

  final namaController = TextEditingController();
  final kmController = TextEditingController();

  DateTime? selectedDate;
  int interval = 30;

  Future<void> pilihTanggal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Kendaraan")),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: namaController,
              decoration: InputDecoration(
                labelText: "Nama Kendaraan",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 12),

            InkWell(
              onTap: () => pilihTanggal(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: "Tanggal Servis Terakhir",
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  selectedDate == null
                      ? "Pilih tanggal"
                      : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                ),
              ),
            ),

            SizedBox(height: 12),

            TextField(
              controller: kmController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Kilometer Terakhir",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 12),

            DropdownButtonFormField<int>(
              value: interval,
              decoration: InputDecoration(
                labelText: "Interval Servis",
                border: OutlineInputBorder(),
              ),
              items: [30, 60, 90]
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text("$e Hari"),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  interval = value!;
                });
              },
            ),

            SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {

                if (namaController.text.isEmpty ||
                    kmController.text.isEmpty ||
                    selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Isi semua data!")),
                  );
                  return;
                }

                final kendaraan = Kendaraan(
                  nama: namaController.text,
                  servisTerakhir: selectedDate!,
                  kilometer: int.parse(kmController.text),
                  intervalHari: interval,
                );

                Navigator.pop(context, kendaraan);
              },
              child: Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}