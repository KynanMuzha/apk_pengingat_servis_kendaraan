class Kendaraan {
  String nama;
  DateTime servisTerakhir;
  int kilometer;
  int intervalHari;

  Kendaraan({
    required this.nama,
    required this.servisTerakhir,
    required this.kilometer,
    required this.intervalHari,
  });

  DateTime get servisBerikutnya {
    return servisTerakhir.add(Duration(days: intervalHari));
  }
}