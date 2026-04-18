import 'package:flutter/material.dart';

class PengaturanScreen extends StatelessWidget {
  const PengaturanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Pengaturan",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Pengaturan",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [

                  Row(
                    children: [
                      Icon(Icons.calendar_today),
                      SizedBox(width: 10),
                      Expanded(child: Text("Hari Pengingat Servis")),
                    ],
                  ),

                  SizedBox(height: 10),

                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  Divider(),

                  Row(
                    children: [
                      Icon(Icons.notifications),
                      SizedBox(width: 10),
                      Text("Notifikasi"),
                      Spacer(),
                      Switch(
                        value: true,
                        onChanged: (value) {},
                      )
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            Text(
              "Tampilan",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.dark_mode),
                  SizedBox(width: 10),
                  Text("Mode Gelap"),
                  Spacer(),
                  Switch(
                    value: false,
                    onChanged: (value) {},
                  )
                ],
              ),
            ),

            SizedBox(height: 20),

            Text(
              "Tentang",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.info),
                  SizedBox(width: 10),
                  Text("Tentang Aplikasi"),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),

            Spacer(),

            Center(
              child: Text(
                "v1.0 2026 Apk by Kynamnuzhaa",
                style: TextStyle(color: Colors.grey[600]),
              ),
            )
          ],
        ),
      ),
    );
  }
}