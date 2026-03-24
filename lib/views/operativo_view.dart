import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/zona_model.dart';
import '../widgets/tarjeta_zona.dart';
import '../widgets/form_nutricion.dart';
import '../widgets/form_sanidad.dart';
import '../widgets/form_cosecha.dart';
import '../widgets/form_aplicacion.dart'; // <--- NUEVO IMPORT

class VistaZonificacionReal extends StatelessWidget {
  const VistaZonificacionReal({super.key});

  @override
  Widget build(BuildContext context) {
    final streamZonas = Supabase.instance.client
        .from('cuaderno_siembra_zona')
        .stream(primaryKey: ['id']).order('zona_id');

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: streamZonas,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(color: Colors.greenAccent));
        }
        
        final activas = snapshot.data!;

        return GridView.builder(
          padding: const EdgeInsets.all(15),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, 
            childAspectRatio: 1.0, 
            crossAxisSpacing: 12, 
            mainAxisSpacing: 12
          ),
          itemCount: 14,
          itemBuilder: (context, index) {
            final idZona = index + 1;
            final rawData = activas.any((z) => z['zona_id'] == idZona) 
                ? activas.firstWhere((z) => z['zona_id'] == idZona) 
                : {'zona_id': idZona};
            
            final zona = ZonaCultivo.fromMap(rawData);

            return TarjetaZona(
              zona: zona,
              onTap: () => _mostrarPanelControl(context, zona),
            );
          },
        );
      },
    );
  }

  void _mostrarPanelControl(BuildContext context, ZonaCultivo zona) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25))
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "GESTIÓN TÁCTICA: ZONA ${zona.id}", 
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.greenAccent)
            ),
            const Divider(height: 30, color: Colors.white10),
            
            // 1. REGISTRAR APLICACIÓN (NUEVO)
            _botonAccion(
              context, 
              "REGISTRAR APLICACIÓN (RIEGO/QUÍMICOS)", 
              Icons.fact_check, 
              Colors.blueAccent,
              onTap: () {
                Navigator.pop(context); 
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: const Color(0xFF1A1A1A),
                  builder: (context) => FormAplicacion(zonaId: zona.id),
                );
              }
            ),
            const SizedBox(height: 10),

            // 2. REGISTRAR NUTRICIÓN
            _botonAccion(
              context, 
              "REGISTRAR NUTRICIÓN (pH/CE)", 
              Icons.water_drop, 
              Colors.cyanAccent,
              onTap: () {
                Navigator.pop(context); 
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: const Color(0xFF1A1A1A),
                  builder: (context) => FormNutricion(zonaId: zona.id),
                );
              }
            ),
            const SizedBox(height: 10),

            // 3. REPORTE DE SANIDAD
            _botonAccion(
              context, 
              "REPORTE DE SANIDAD (PLAGAS)", 
              Icons.bug_report, 
              Colors.orangeAccent,
              onTap: () {
                Navigator.pop(context); 
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: const Color(0xFF1A1A1A),
                  builder: (context) => FormSanidad(zonaId: zona.id),
                );
              },
            ),
            const SizedBox(height: 10),

            // 4. FINALIZAR COSECHA
            _botonAccion(
              context, 
              "FINALIZAR COSECHA", 
              Icons.shopping_basket, 
              Colors.redAccent,
              onTap: () {
                Navigator.pop(context); 
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: const Color(0xFF1A1A1A),
                  builder: (context) => FormCosecha(zonaId: zona.id),
                );
              },
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _botonAccion(BuildContext context, String titulo, IconData icono, Color color, {required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icono, color: Colors.black, size: 18),
        label: Text(
          titulo, 
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}