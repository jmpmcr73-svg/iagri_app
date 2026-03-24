import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'views/operativo_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://xeffvoyhnzxkdkhetsum.supabase.co',
    anonKey: 'sb_publishable_JrsHdcDaaOVQZEkDlVLkVg_5Ash43gf', 
  );
  runApp(const iAgriMasterApp());
}

class iAgriMasterApp extends StatelessWidget {
  const iAgriMasterApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.greenAccent,
      ),
      home: const NaveAlfaMaster(),
    );
  }
}

class NaveAlfaMaster extends StatelessWidget {
  const NaveAlfaMaster({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("iAGRI OS - NAVE 1", 
          style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 14)),
        backgroundColor: const Color(0xFF1A1A1A),
        centerTitle: true,
      ),
      // Invocamos la vista que está en el otro archivo
      body: const VistaZonificacionReal(),
    );
  }
}
