import 'package:hive/hive.dart';

part 'kendaraan.g.dart';

@HiveType(typeId: 0)
class Kendaraan extends HiveObject {

  @HiveField(0)
  String nama;

  @HiveField(1)
  int km;

  @HiveField(2)
  int interval; // dalam hari

  @HiveField(3)
  DateTime servisTerakhir;

  @HiveField(4)
  String jenis; // Mobil / Motor

  Kendaraan({
    required this.nama,
    required this.km,
    required this.interval,
    required this.servisTerakhir,
    required this.jenis,
  });

  // ================= LOGIC =================

  /// 🔥 Hitung servis berikutnya
  DateTime get servisBerikutnya {
    return servisTerakhir.add(Duration(days: interval));
  }

  /// 🔥 Sisa hari ke servis berikutnya
  int get sisaHari {
    return servisBerikutnya.difference(DateTime.now()).inDays;
  }

  /// 🔥 Status: terlambat
  bool get isOverdue => sisaHari < 0;

  /// 🔥 Status: urgent (0–3 hari)
  bool get isUrgent => sisaHari >= 0 && sisaHari <= 3;

  /// 🔥 Status: hampir (4–7 hari)
  bool get isSoon => sisaHari > 3 && sisaHari <= 7;
}