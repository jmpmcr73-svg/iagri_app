import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FormNutricion extends StatefulWidget {
  final int zonaId;
  const FormNutricion({super.key, required this.zonaId});

  @override
  State<FormNutricion> createState() => _FormNutricionState();
}

class _FormNutricionState extends State<FormNutricion> {
  final _phController = TextEditingController();
  final _ceController = TextEditingController();
  bool _cargando = false;

  Future<void> _guardarDatos() async {
    setState(() => _cargando = true);
    try {
      await Supabase.instance.client.from('cuaderno_siembra_zona').update({
        'ph_salida_real': double.parse(_phController.text),
        'ce_salida_real': double.parse(_ceController.text),
      }).eq('zona_id', widget.zonaId);
      
      if (mounted) Navigator.pop(context); // Cierra el formulario al terminar
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: Revisa que los números sean válidos")),
      );
    }
    setState(() => _cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Ajuste para el teclado
        left: 25, right: 25, top: 25
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("LECTURA DE NUTRICIÓN - ZONA ${widget.zonaId}", 
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          const SizedBox(height: 20),
          TextField(
            controller: _phController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: "pH de Salida", suffixText: "pH"),
          ),
          TextField(
            controller: _ceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: "Conductividad Eléctrica", suffixText: "mS/cm"),
          ),
          const SizedBox(height: 30),
          _cargando 
            ? const CircularProgressIndicator()
            : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _guardarDatos,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  child: const Text("GUARDAR EN NUBE", style: TextStyle(color: Colors.white)),
                ),
              ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}