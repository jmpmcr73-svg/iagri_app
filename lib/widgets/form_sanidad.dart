import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FormSanidad extends StatefulWidget {
  final int zonaId;
  const FormSanidad({super.key, required this.zonaId});

  @override
  State<FormSanidad> createState() => _FormSanidadState();
}

class _FormSanidadState extends State<FormSanidad> {
  String _plagaSeleccionada = 'Ninguna';
  double _incidencia = 0;
  bool _cargando = false;

  final List<String> _catalogoPlagas = [
    'Ninguna', 
    'Mosca Blanca', 
    'Arañita Roja', 
    'Trips', 
    'Minador', 
    'Oidio', 
    'Botrytis'
  ];

  Future<void> _guardarSanidad() async {
    setState(() => _cargando = true);
    try {
      // Actualizamos Supabase con la lógica de bioseguridad
      await Supabase.instance.client.from('cuaderno_siembra_zona').update({
        'nombre_plaga': _plagaSeleccionada,
        'incidencia_plaga_pct': _incidencia.toInt(),
        'estado_bioseguridad': _incidencia > 5 ? 'En Observación' : 'Limpio',
      }).eq('zona_id', widget.zonaId);
      
      if (mounted) {
        Navigator.pop(context); // Cierra el modal
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Sanidad Actualizada"),
            backgroundColor: Colors.orangeAccent,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error en Sanidad: $e");
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 25, 
        right: 25, 
        top: 25, 
        bottom: MediaQuery.of(context).viewInsets.bottom + 25
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "REPORTE DE SANIDAD", 
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orangeAccent, fontSize: 18)
          ),
          const SizedBox(height: 10),
          Text("ZONA ${widget.zonaId}", style: const TextStyle(color: Colors.white38, fontSize: 12)),
          const Divider(height: 30, color: Colors.white10),
          
          DropdownButtonFormField<String>(
            value: _plagaSeleccionada,
            dropdownColor: const Color(0xFF252525),
            style: const TextStyle(color: Colors.white),
            items: _catalogoPlagas.map((p) => DropdownMenuItem(
              value: p, 
              child: Text(p)
            )).toList(),
            onChanged: (val) => setState(() => _plagaSeleccionada = val!),
            decoration: const InputDecoration(
              labelText: "Tipo de Plaga/Enfermedad",
              labelStyle: TextStyle(color: Colors.orangeAccent),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orangeAccent)),
            ),
          ),
          
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Nivel de Incidencia:", style: TextStyle(color: Colors.white70)),
              Text(
                "${_incidencia.toInt()}%", 
                style: TextStyle(
                  color: _incidencia > 5 ? Colors.redAccent : Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                )
              ),
            ],
          ),
          
          Slider(
            value: _incidencia,
            min: 0, 
            max: 100,
            divisions: 20,
            activeColor: _incidencia > 5 ? Colors.redAccent : Colors.orangeAccent,
            inactiveColor: Colors.white10,
            onChanged: (val) => setState(() => _incidencia = val),
          ),
          
          const SizedBox(height: 30),
          _cargando 
            ? const CircularProgressIndicator(color: Colors.orangeAccent)
            : SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _guardarSanidad,
                  icon: const Icon(Icons.send, size: 18),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.black,
                  ),
                  label: const Text("NOTIFICAR HALLAZGO", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
        ],
      ),
    );
  }
}