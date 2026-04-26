import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/home_screen.dart';
import 'models/kendaraan.dart';
import 'models/service_model.dart';
import 'app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ================= INIT HIVE =================
  await Hive.initFlutter();

  // ================= REGISTER ADAPTER =================
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(KendaraanAdapter());
  }

  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(ServiceModelAdapter());
  }

  // ================= OPEN BOX =================
  await Hive.openBox<Kendaraan>('kendaraanBox');
  await Hive.openBox<ServiceModel>('serviceBox');

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