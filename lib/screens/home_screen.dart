import 'package:flutter/material.dart';
import '../models/kendaraan.dart';
import 'tambah_screen.dart';
import 'edit_screen.dart';
import 'detail_screen.dart';
import 'pengaturan_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Kendaraan> data = [];
  List<Kendaraan> filteredData = [];

  @override
  void initState() {
    super.initState();
    filteredData = data;
  }

  String formatTanggal(DateTime date) {
    return "${date.day} Jan ${date.year}";
  }

  void searchKendaraan(String query) {
    final hasil = data.where((item) {
      return item.nama.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredData = hasil;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.close, color: Colors.white),
            ),
            SizedBox(width: 10),
            Text(
              "Pengingat Servis Kendaraan",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black),
            onPressed: () async {
              final hasil = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PengaturanScreen(),
                ),
              );

              if (hasil == "refresh") {
                setState(() {});
              }
            },
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                onChanged: searchKendaraan,
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "Cari Kendaraan...",
                  border: InputBorder.none,
                ),
              ),
            ),

            SizedBox(height: 16),

            Expanded(
              child: filteredData.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.directions_car,
                              size: 80, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            "Belum ada kendaraan",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final item = filteredData[index];
                        final nextService = item.servisTerakhir
                            .add(Duration(days: item.intervalHari));

                        final sisaHari =
                            nextService.difference(DateTime.now()).inDays;

                        String status;
                        Color warna;
                        IconData icon;

                        if (sisaHari < 0) {
                          status = "Terlambat Servis";
                          warna = Colors.red;
                          icon = Icons.error;
                        } else if (sisaHari <= 3) {
                          status = "Segera Servis";
                          warna = Colors.orange;
                          icon = Icons.warning;
                        } else {
                          status = "Aman";
                          warna = Colors.green;
                          icon = Icons.check_circle;
                        }

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DetailScreen(kendaraan: item),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 16),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  item.nama,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                Divider(),

                                Text(
                                  "Servis Terakhir: ${formatTanggal(item.servisTerakhir)}",
                                ),
                                Text(
                                  "Servis Berikutnya: ${formatTanggal(nextService)}",
                                ),

                                SizedBox(height: 10),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [

                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: warna.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(icon,
                                              size: 16, color: warna),
                                          SizedBox(width: 5),
                                          Text(
                                            "$status (${sisaHari.abs()} hari)",
                                            style:
                                                TextStyle(color: warna),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            final hasil =
                                                await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    EditScreen(
                                                        kendaraan: item),
                                              ),
                                            );

                                            if (hasil != null) {
                                              setState(() {
                                                if (hasil == "delete") {
                                                  data.remove(item);
                                                  filteredData.remove(item);
                                                } else {
                                                  int i =
                                                      data.indexOf(item);
                                                  data[i] = hasil;
                                                  filteredData[index] =
                                                      hasil;
                                                }
                                              });
                                            }
                                          },
                                          child: Icon(Icons.edit),
                                        ),
                                        SizedBox(width: 12),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              data.remove(item);
                                              filteredData.remove(item);
                                            });
                                          },
                                          child: Icon(Icons.delete),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.grey,
            onPressed: () async {
              final hasil = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TambahScreen(),
                ),
              );

              if (hasil != null) {
                setState(() {
                  data.add(hasil);
                  filteredData = data;
                });
              }
            },
            child: Icon(Icons.add, size: 30),
          ),
          SizedBox(height: 5),
          Text("Tambah")
        ],
      ),
    );
  }
}