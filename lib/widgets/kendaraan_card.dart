import 'package:flutter/material.dart';
import '../models/kendaraan.dart';

class KendaraanCard extends StatelessWidget {
  final Kendaraan kendaraan;

  KendaraanCard({required this.kendaraan});

  @override
  Widget build(BuildContext context) {
    final nextService = kendaraan.servisBerikutnya;
    final isUrgent = nextService.difference(DateTime.now()).inDays <= 3;

    return Card(
      child: ListTile(
        title: Text(kendaraan.nama),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Servis Terakhir: ${kendaraan.servisTerakhir.toString().split(' ')[0]}"),
            Text("Servis Berikutnya: ${nextService.toString().split(' ')[0]}"),
            Text(isUrgent ? "Segera Servis" : "Aman",
                style: TextStyle(
                    color: isUrgent ? Colors.red : Colors.green)),
          ],
        ),
      ),
    );
  }
}