import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FormCosecha extends StatefulWidget {
  final int zonaId;
  const FormCosecha({super.key, required this.zonaId});

  @override
  State<FormCosecha> createState() => _FormCosechaState();
}

class _FormCosechaState extends State<FormCosecha> {
  final _kilosController = TextEditingController();
  bool _cargando = false;

  Future<void> _registrarCosecha() async {
    if (_kilosController.text.isEmpty) return;
    
    setState(() => _cargando = true);
    try {
      await Supabase.instance.client.from('cuaderno_siembra_zona').update({
        'kilos_cosechados': double.parse(_kilosController.text),
      }).eq('zona_id', widget.zonaId);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cosecha Registrada"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
    setState(() => _cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 25,
        left: 25, right: 25, top: 25
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.shopping_basket, color: Colors.redAccent, size: 40),
          const SizedBox(height: 10),
          Text("REGISTRO DE COSECHA - ZONA ${widget.zonaId}", 
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
          const SizedBox(height: 20),
          TextField(
            controller: _kilosController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: "Kilos Recolectados", suffixText: "kg"),
          ),
          const SizedBox(height: 25),
          _cargando 
            ? const CircularProgressIndicator()
            : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _registrarCosecha,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  child: const Text("GUARDAR COSECHA", style: TextStyle(color: Colors.white)),
                ),
              ),
        ],
      ),
    );
  }
}