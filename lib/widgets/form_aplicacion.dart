import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FormAplicacion extends StatefulWidget {
  final int zonaId;
  const FormAplicacion({super.key, required this.zonaId});

  @override
  State<FormAplicacion> createState() => _FormAplicacionState();
}

class _FormAplicacionState extends State<FormAplicacion> {
  String _tipoActividad = 'Riego';
  String _producto = 'Nitrato de Calcio';
  final _cantidadController = TextEditingController();
  bool _cargando = false;

  // Listas que luego personalizaremos a tu gusto
  final List<String> _tipos = ['Riego', 'Foliar', 'Desinfección', 'Preventivo'];
  final List<String> _productosDefecto = [
    'Nitrato de Calcio', 'Nitrato de Potasio', 'Sulfato de Magnesio', 
    'Ácido Fosfórico', 'Amoneo Cuaternario', 'Aminoácidos', 'Fungicida'
  ];

  Future<void> _guardarAplicacion() async {
    if (_cantidadController.text.isEmpty) return;
    setState(() => _cargando = true);

    try {
      await Supabase.instance.client.from('bitacora_aplicaciones').insert({
        'zona_id': widget.zonaId,
        'nave_id': 1, // Por ahora fijo, luego lo hacemos dinámico
        'tipo_aplicacion': _tipoActividad,
        'producto': _producto,
        'cantidad': double.parse(_cantidadController.text),
        'unidad': _tipoActividad == 'Riego' ? 'kg' : 'L',
        'costo_estimado': 0.0, // Para llenar después
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Aplicación Registrada"), backgroundColor: Colors.blueAccent),
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
          const Text("NUEVA APLICACIÓN TÉCNICA", 
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 16)),
          const SizedBox(height: 20),
          
          DropdownButtonFormField<String>(
            value: _tipoActividad,
            items: _tipos.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: (val) => setState(() => _tipoActividad = val!),
            decoration: const InputDecoration(labelText: "Tipo de Actividad"),
          ),
          
          const SizedBox(height: 15),
          
          DropdownButtonFormField<String>(
            value: _producto,
            items: _productosDefecto.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
            onChanged: (val) => setState(() => _producto = val!),
            decoration: const InputDecoration(labelText: "Producto / Insumo"),
          ),
          
          const SizedBox(height: 15),
          
          TextField(
            controller: _cantidadController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Cantidad",
              suffixText: _tipoActividad == 'Riego' ? 'kg' : 'L',
            ),
          ),
          
          const SizedBox(height: 30),
          
          _cargando 
            ? const CircularProgressIndicator()
            : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _guardarAplicacion,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  child: const Text("REGISTRAR EN BITÁCORA", style: TextStyle(color: Colors.white)),
                ),
              ),
        ],
      ),
    );
  }
  _botonAccion(
  context, 
  "REGISTRAR APLICACIÓN / RIEGO", 
  Icons.add_task, 
  Colors.blueAccent,
  onTap: () {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      builder: (context) => FormAplicacion(zonaId: zona.id),
    );
  },
),
}