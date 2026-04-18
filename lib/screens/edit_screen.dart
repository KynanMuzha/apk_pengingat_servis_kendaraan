import 'package:flutter/material.dart';
import '../models/kendaraan.dart';

class EditScreen extends StatefulWidget {
  final Kendaraan kendaraan;

  EditScreen({required this.kendaraan});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {

  late TextEditingController namaController;
  late TextEditingController kmController;

  DateTime? selectedDate;
  int interval = 30;

  @override
  void initState() {
    super.initState();

    namaController = TextEditingController(text: widget.kendaraan.nama);
    kmController = TextEditingController(
        text: widget.kendaraan.kilometer.toString());

    selectedDate = widget.kendaraan.servisTerakhir;
    interval = widget.kendaraan.intervalHari;
  }

  Future<void> pilihTanggal(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
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
      appBar: AppBar(title: Text("Edit Kendaraan")),

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
                  "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                ),
              ),
            ),

            SizedBox(height: 12),

            TextField(
              controller: kmController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Kilometer",
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
              onChanged: (val) {
                setState(() {
                  interval = val!;
                });
              },
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                final updated = Kendaraan(
                  nama: namaController.text,
                  servisTerakhir: selectedDate!,
                  kilometer: int.parse(kmController.text),
                  intervalHari: interval,
                );

                Navigator.pop(context, updated);
              },
              child: Text("Simpan"),
            ),

            SizedBox(height: 10),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context, "delete");
              },
              child: Text("Hapus Kendaraan"),
            )
          ],
        ),
      ),
    );
  }
}