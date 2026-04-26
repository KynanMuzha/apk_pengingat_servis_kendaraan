import 'package:flutter/material.dart';
import '../models/kendaraan.dart';
import '../app_colors.dart';
import '../screens/tambah_screen.dart';

class KendaraanCard extends StatelessWidget {
  final Kendaraan kendaraan;
  final VoidCallback? onTap;

  const KendaraanCard({
    super.key,
    required this.kendaraan,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final nextService = kendaraan.servisBerikutnya;
    final now = DateTime.now();
    final difference = nextService.difference(now).inDays;

    final isOverdue = difference < 0;
    final isUrgent = difference >= 0 && difference <= 3;
    final isSoon = difference > 3 && difference <= 7;

    Color statusColor;
    String statusText;
    String statusDesc;

    if (isOverdue) {
      statusColor = Colors.red;
      statusText = "TERLAMBAT";
      statusDesc = "Servis sudah terlewat";
    } else if (isUrgent) {
      statusColor = Colors.red;
      statusText = "SEGERA SERVIS";
      statusDesc = "Segera lakukan servis";
    } else if (isSoon) {
      statusColor = Colors.orange;
      statusText = "HAMPIR SERVIS";
      statusDesc = "Servis dalam beberapa hari";
    } else {
      statusColor = AppColors.primary;
      statusText = "AMAN";
      statusDesc = "Kondisi Prima";
    }

    return GestureDetector(
      onTap: onTap,
      child: Dismissible(
        key: Key(kendaraan.key.toString()),
        direction: DismissDirection.endToStart,

        background: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Icon(Icons.delete, color: Colors.white, size: 28),
        ),

        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Hapus Kendaraan"),
              content: const Text("Yakin ingin menghapus data ini?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Batal"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Hapus"),
                ),
              ],
            ),
          );
        },

        onDismissed: (direction) {
          kendaraan.delete();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Kendaraan dihapus")),
          );
        },

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [

              // ===== GARIS STATUS =====
              Container(
                width: 5,
                height: 160,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ===== BADGE STATUS =====
                      if (isOverdue || isUrgent || isSoon)
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      // ===== ICON + NAMA =====
                      Row(
                        children: [
                          Icon(
                            kendaraan.jenis == "Mobil"
                                ? Icons.directions_car
                                : Icons.motorcycle,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),

                          Expanded(
                            child: Text(
                              kendaraan.nama,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),

                          Row(
                            children: [

                              // EDIT
                              GestureDetector(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => TambahScreen(
                                        kendaraan: kendaraan,
                                      ),
                                    ),
                                  );
                                },
                                child: const Icon(Icons.edit,
                                    size: 18, color: Colors.grey),
                              ),

                              const SizedBox(width: 12),

                              // DELETE
                              GestureDetector(
                                onTap: () async {
                                  final confirm = await showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text("Hapus Kendaraan"),
                                      content: const Text(
                                          "Yakin ingin menghapus data ini?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text("Batal"),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text("Hapus"),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    kendaraan.delete();
                                  }
                                },
                                child: const Icon(Icons.delete,
                                    size: 18, color: Colors.grey),
                              ),
                            ],
                          )
                        ],
                      ),

                      const SizedBox(height: 6),

                      // ===== LABEL JENIS =====
                      Text(
                        kendaraan.jenis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "SERVIS TERAKHIR",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(_formatFullDate(kendaraan.servisTerakhir)),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "SERVIS BERIKUTNYA",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            _formatShortDate(nextService),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),
                      Divider(color: AppColors.textSecondary.withOpacity(0.2)),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              statusText,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            statusDesc,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    const bulan = [
      "Jan", "Feb", "Mar", "Apr", "Mei", "Jun",
      "Jul", "Agu", "Sep", "Okt", "Nov", "Des"
    ];
    return "${date.day} ${bulan[date.month - 1]} ${date.year}";
  }

  String _formatShortDate(DateTime date) {
    const bulan = [
      "Jan", "Feb", "Mar", "Apr", "Mei", "Jun",
      "Jul", "Agu", "Sep", "Okt", "Nov", "Des"
    ];
    return "${date.day} ${bulan[date.month - 1]}";
  }
}