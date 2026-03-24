import 'package:flutter/material.dart'; // <-- Revisa que tenga la 'i'
import '../models/zona_model.dart';

class TarjetaZona extends StatelessWidget {
  final ZonaCultivo zona;
  final VoidCallback onTap;

  const TarjetaZona({super.key, required this.zona, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Definimos si hay alerta (incidencia mayor a 5%)
    bool alerta = zona.incidenciaPlaga > 5;
    
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          // Si hay alerta, fondo rojizo, si no, gris oscuro
          color: alerta ? const Color(0xFF421010) : const Color(0xFF252525),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: alerta ? Colors.redAccent : Colors.greenAccent, 
            width: 2
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "ZONA ${zona.id}", 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)
            ),
            const SizedBox(height: 10),
            Text(
              zona.variedad, 
              style: const TextStyle(fontSize: 12, color: Colors.white70)
            ),
          ],
        ),
      ),
    );
  }
}