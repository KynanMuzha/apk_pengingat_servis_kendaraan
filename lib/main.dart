import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/home_screen.dart';
import 'models/kendaraan.dart';
import 'models/service_model.dart'; // 🔥 TAMBAH INI
import 'app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 INIT HIVE
  await Hive.initFlutter();

  // 🔥 REGISTER ADAPTER
  Hive.registerAdapter(KendaraanAdapter());
  Hive.registerAdapter(ServiceModelAdapter()); // 🔥 WAJIB

  // 🔥 BUKA DATABASE
  await Hive.openBox<Kendaraan>('kendaraanBox');
  await Hive.openBox<ServiceModel>('serviceBox'); // 🔥 WAJIB

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: false,
        primaryColor: AppColors.primary,

        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
      ),

      home: const HomeScreen(),
    );
  }
}