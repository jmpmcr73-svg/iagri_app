import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/bitacora_model.dart';
import 'package:intl/intl.dart'; // Para dar formato a la fecha

class BitacoraZonaView extends StatelessWidget {
  final int zonaId;
  const BitacoraZonaView({super.key, required this.zonaId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: Text("Historial Zona $zonaId"),
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        // Filtramos por zona_id y ordenamos por fecha más reciente
        stream: Supabase.instance.client
            .from('bitacora_applications')
            .stream(primaryKey: ['id'])
            .eq('zona_id', zonaId)
            .order('fecha_aplicacion'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final registros = snapshot.data!.map((map) => BitacoraRegistro.fromMap(map)).toList();

          if (registros.isEmpty) {
            return const Center(child: Text("No hay aplicaciones registradas", style: TextStyle(color: Colors.white38)));
          }

          return ListView.builder(
            itemCount: registros.length,
            itemBuilder: (context, index) {
              final item = registros[index];
              return Card(
                color: const Color(0xFF1A1A1A),
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: ListTile(
                  leading: Icon(
                    item.tipo == 'Riego' ? Icons.water_drop : Icons.Science,
                    color: item.tipo == 'Riego' ? Colors.blue : Colors.purpleAccent,
                  ),
                  title: Text(item.producto, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text("${item.tipo} - ${DateFormat('dd MMM, hh:mm a').format(item.fecha)}", 
                    style: const TextStyle(color: Colors.white60)),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("${item.cantidad} ${item.unidad}", style: const TextStyle(color: Colors.greenAccent)),
                      Text("\$${item.costo}", style: const TextStyle(color: Colors.white38, fontSize: 10)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}