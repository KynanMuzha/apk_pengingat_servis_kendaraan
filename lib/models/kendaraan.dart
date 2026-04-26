class Kendaraan {
  final String nama;
  final int km;
  final int interval; // dalam hari
  final DateTime servisTerakhir;

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

  // 🔥 Status (urgent atau tidak)
  bool get isUrgent {
    return servisBerikutnya.isBefore(DateTime.now());
  }
}