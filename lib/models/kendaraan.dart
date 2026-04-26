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

  // 🔥 Hitung servis berikutnya
  DateTime get servisBerikutnya {
    return servisTerakhir.add(Duration(days: interval));
  }

  // 🔥 Status
  bool get isUrgent {
    return servisBerikutnya.isBefore(DateTime.now());
  }
}