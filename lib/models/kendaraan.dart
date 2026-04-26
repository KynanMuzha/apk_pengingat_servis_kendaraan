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

  Kendaraan({
    required this.nama,
    required this.km,
    required this.interval,
    required this.servisTerakhir,
  });

  // ================= LOGIC =================

  /// 🔥 Hitung servis berikutnya
  DateTime get servisBerikutnya {
    return servisTerakhir.add(Duration(days: interval));
  }

  /// 🔥 Selisih hari ke servis berikutnya
  int get sisaHari {
    return servisBerikutnya.difference(DateTime.now()).inDays;
  }

  /// 🔥 Status: terlambat
  bool get isOverdue {
    return sisaHari < 0;
  }

  /// 🔥 Status: urgent (0–3 hari)
  bool get isUrgent {
    return sisaHari >= 0 && sisaHari <= 3;
  }

  /// 🔥 Status: hampir (4–7 hari)
  bool get isSoon {
    return sisaHari > 3 && sisaHari <= 7;
  }
}