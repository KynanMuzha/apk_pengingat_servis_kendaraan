import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'tambah_screen.dart';
import '../models/kendaraan.dart';
import '../widgets/kendaraan_card.dart';
import '../app_colors.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final box = Hive.box<Kendaraan>('kendaraanBox');

  Future<void> _tambahKendaraan() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TambahScreen(),
      ),
    );

    if (result != null) {
      box.add(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ================= APPBAR =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.menu, color: AppColors.primary),
        title: const Text(
          "GARASI",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.account_circle,
                color: AppColors.primary, size: 28),
          )
        ],
      ),

      // ================= BODY =================
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.background,
                    const Color(0xFFE9EEF8),
                  ],
                ),
              ),
              child: Column(
                children: [

                  // ================= HERO =================
                  ValueListenableBuilder(
                    valueListenable: box.listenable(),
                    builder: (context, Box<Kendaraan> box, _) {
                      return Container(
                        margin: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withOpacity(0.2),
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
                                  const Text(
                                    "Pengingat Servis",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    box.isEmpty
                                        ? "Belum ada data"
                                        : "${box.length} kendaraan tersimpan",
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // 🔥 ICON NETRAL (SERVICE)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.build_circle,
                                color: AppColors.primary,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),

                  // ================= CONTENT =================
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ValueListenableBuilder(
                        valueListenable: box.listenable(),
                        builder: (context, Box<Kendaraan> box, _) {

                          final vehicles = box.values.toList();

                          // ================= EMPTY =================
                          if (vehicles.isEmpty) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Stack(
                                  alignment: Alignment.center,
                                  children: [

                                    // layer 1
                                    Container(
                                      width: 220,
                                      height: 220,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primary.withOpacity(0.04),
                                      ),
                                    ),

                                    // layer 2
                                    Container(
                                      width: 170,
                                      height: 170,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primary.withOpacity(0.08),
                                      ),
                                    ),

                                    // 🔥 ICON UTAMA
                                    Container(
                                      padding: const EdgeInsets.all(30),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.08),
                                            blurRadius: 30,
                                            offset: const Offset(0, 10),
                                          )
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.build_circle,
                                        size: 60,
                                        color: AppColors.primary,
                                      ),
                                    ),

                                    // 🔥 AKSEN KECIL
                                    Positioned(
                                      top: 30,
                                      left: 40,
                                      child: Icon(Icons.directions_car,
                                          size: 18,
                                          color: Colors.grey.withOpacity(0.6)),
                                    ),

                                    Positioned(
                                      bottom: 30,
                                      right: 40,
                                      child: Icon(Icons.motorcycle,
                                          size: 18,
                                          color: Colors.grey.withOpacity(0.6)),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 30),

                                const Text(
                                  "Belum ada data servis",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                const Text(
                                  "Tambahkan kendaraan untuk mulai memantau dan mengelola servis secara praktis.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    height: 1.6,
                                  ),
                                ),

                                const SizedBox(height: 36),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: _tambahKendaraan,
                                    icon: const Icon(Icons.add),
                                    label: const Text("Tambah Kendaraan"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      padding: const EdgeInsets.symmetric(vertical: 18),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }

                          // ================= LIST =================
                          return ListView.builder(
                            padding: const EdgeInsets.only(bottom: 100),
                            itemCount: vehicles.length,
                            itemBuilder: (context, index) {
                              final kendaraan = vehicles[index];

                              return KendaraanCard(
                                kendaraan: kendaraan,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailScreen(kendaraan: kendaraan),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ================= NAVBAR =================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(color: Colors.white),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              NavItem(icon: Icons.garage, label: "Garasi", active: true),
              NavItem(icon: Icons.show_chart, label: "Riwayat", active: false),
              NavItem(icon: Icons.settings, label: "Pengaturan", active: false),
            ],
          ),
        ),
      ),

      // ================= FAB =================
      floatingActionButton: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Kendaraan> box, _) {
          if (box.isEmpty) return const SizedBox();

          return FloatingActionButton.extended(
            onPressed: _tambahKendaraan,
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add),
            label: const Text("Tambah"),
          );
        },
      ),
    );
  }
}

// ================= NAV ITEM =================
class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: active ? AppColors.primary : Colors.grey,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: active ? AppColors.primary : Colors.grey,
          ),
        ),
      ],
    );
  }
}