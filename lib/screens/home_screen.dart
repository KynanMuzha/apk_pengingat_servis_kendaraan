import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'tambah_screen.dart';
import '../models/kendaraan.dart';
import '../widgets/kendaraan_card.dart';
import '../app_colors.dart';

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
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const Icon(Icons.menu, color: AppColors.primary),
        title: const Text(
          "GARASI",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
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
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background,
                    const Color(0xFFE9EEF8),
                  ],
                ),
              ),
              child: SafeArea(
                top: false,
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
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.1),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              )
                            ],
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
                                          ? "Belum ada kendaraan"
                                          : "${box.length} kendaraan terdaftar",
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.directions_car,
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

                            // EMPTY STATE
                            if (vehicles.isEmpty) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 200,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primary.withOpacity(0.05),
                                        ),
                                      ),
                                      Container(
                                        width: 150,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primary.withOpacity(0.1),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(28),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.08),
                                              blurRadius: 25,
                                              offset: const Offset(0, 10),
                                            )
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.directions_car,
                                          size: 55,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 30),

                                  const Text(
                                    "Belum ada kendaraan",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  const Text(
                                    "Tambahkan kendaraan untuk mulai memantau jadwal servis dengan mudah.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      height: 1.6,
                                    ),
                                  ),

                                  const SizedBox(height: 30),

                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: _tambahKendaraan,
                                      icon: const Icon(Icons.add),
                                      label: const Text("Tambah Kendaraan"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 18),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(40),
                                        ),
                                        elevation: 8,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }

                            // LIST DATA
                            return ListView.builder(
                              padding: const EdgeInsets.only(bottom: 100),
                              itemCount: vehicles.length,
                              itemBuilder: (context, index) {
                                final kendaraan = vehicles[index];

                                return AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: KendaraanCard(
                                    key: ValueKey(kendaraan.key),
                                    kendaraan: kendaraan,
                                  ),
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
          ),
        ],
      ),

      // ================= NAVBAR =================
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              NavItem(icon: Icons.directions_car, label: "Garasi", active: true),
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
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: active
                ? AppColors.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 24,
            color: active
                ? AppColors.primary
                : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
            color: active
                ? AppColors.primary
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}