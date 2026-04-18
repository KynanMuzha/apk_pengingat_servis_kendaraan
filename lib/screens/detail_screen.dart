import 'package:flutter/material.dart';
import '../models/kendaraan.dart';

class DetailScreen extends StatefulWidget {
  final Kendaraan kendaraan;

  const DetailScreen({Key? key, required this.kendaraan}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  List<Map<String, dynamic>> riwayat = [];

  String formatTanggal(DateTime date) {
    return "${date.day} Jan ${date.year}";
  }

  @override
  void initState() {
    super.initState();

    riwayat.add({
      "tanggal": widget.kendaraan.servisTerakhir,
      "km": widget.kendaraan.kilometer
    });
  }

  @override
  Widget build(BuildContext context) {

    final nextService = widget.kendaraan.servisTerakhir
        .add(Duration(days: widget.kendaraan.intervalHari));

    final sisaHari =
        nextService.difference(DateTime.now()).inDays;

    final isUrgent = sisaHari <= 3;

    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        title: Text(widget.kendaraan.nama),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(isUrgent ? Icons.warning : Icons.check_circle),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isUrgent
                          ? "Segera Servis! ($sisaHari hari lagi)"
                          : "Aman ($sisaHari hari lagi)",
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Servis Terakhir",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(formatTanggal(widget.kendaraan.servisTerakhir)),

            const SizedBox(height: 10),

            const Text(
              "Kilometer",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("${widget.kendaraan.kilometer} km"),

            const SizedBox(height: 20),

            const Text(
              "Riwayat Servis",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: riwayat.length,
                itemBuilder: (context, index) {
                  final item = riwayat[index];

                  final tanggal = item["tanggal"] as DateTime;
                  final km = item["km"] as int;

                  return ListTile(
                    title: Text(
                      "Servis pada ${formatTanggal(tanggal)}",
                    ),
                    subtitle: Text("$km km"),
                  );
                },
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                setState(() {
                  final now = DateTime.now();

                  riwayat.insert(0, {
                    "tanggal": now,
                    "km": widget.kendaraan.kilometer
                  });

                  widget.kendaraan.servisTerakhir = now;
                });
              },
              child: const Text("Tandai Sudah Servis"),
            )
          ],
        ),
      ),
    );
  }
}