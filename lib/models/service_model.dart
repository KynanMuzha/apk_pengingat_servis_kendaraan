import 'package:hive/hive.dart';

part 'service_model.g.dart';

@HiveType(typeId: 1)
class ServiceModel extends HiveObject {
  @HiveField(0)
  String namaServis;

  @HiveField(1)
  DateTime tanggal;

  @HiveField(2)
  int biaya;

  @HiveField(3)
  int km;

  @HiveField(4)
  int kendaraanKey; // 🔥 relasi ke kendaraan

  ServiceModel({
    required this.namaServis,
    required this.tanggal,
    required this.biaya,
    required this.km,
    required this.kendaraanKey,
  });
}