// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kendaraan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KendaraanAdapter extends TypeAdapter<Kendaraan> {
  @override
  final int typeId = 0;

  @override
  Kendaraan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Kendaraan(
      nama: fields[0] as String,
      km: fields[1] as int,
      interval: fields[2] as int,
      servisTerakhir: fields[3] as DateTime,
      jenis: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Kendaraan obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.nama)
      ..writeByte(1)
      ..write(obj.km)
      ..writeByte(2)
      ..write(obj.interval)
      ..writeByte(3)
      ..write(obj.servisTerakhir)
      ..writeByte(4)
      ..write(obj.jenis);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KendaraanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
