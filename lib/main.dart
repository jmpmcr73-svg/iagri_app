import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // CONEXIÓN AL NÚCLEO iAGRI
  await Supabase.initialize(
    url: 'https://xeffvoyhnzxkdkhetsum.supabase.co',
    anonKey: 'sb_publishable_JrsHdcDaaOVQZEkDlVLkVg_5Ash43gf', // <--- REEMPLAZA ESTO CON TU ANON KEY
  );
 runApp(const iAgriMasterApp());
}
 class iAgriMasterApp extends StatelessWidget {
  const iAgriMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema Alejandría',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      ),
      home: const DashboardHome(),
    );
  }
}

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  void _mostrarChatAgentes(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => const VentanaChat(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Stream en tiempo real de los activos
    final Stream<List<Map<String, dynamic>>> _activosStream = 
        Supabase.instance.client.from('activos_maestros').stream(primaryKey: ['id']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CENTRO DE MANDO iAGRI', style: TextStyle(letterSpacing: 2)),
        backgroundColor: Colors.black,
        elevation: 10,
      ),
      
      floatingActionButton: SizedBox(
        width: 160,
        height: 50,
        child: FloatingActionButton.extended(
          onPressed: () => _mostrarChatAgentes(context),
          label: const Text(
            'AGENTES IA', 
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)
          ),
          icon: const Icon(Icons.psychology),
          backgroundColor: Colors.greenAccent.shade700,
        ),
      ),

      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _activosStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final activos = snapshot.data!;

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.green.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat("Activos", activos.length.toString()),
                    _buildStat("Alertas", "0"),
                    _buildStat("Agentes", "14"),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: activos.length,
                  itemBuilder: (context, index) {
                    final item = activos[index];
                    return _buildActivoCard(item);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActivoCard(Map<String, dynamic> item) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.withOpacity(0.2),
          child: Icon(_getIcon(item['tipo_activo']), color: Colors.greenAccent),
        ),
        title: Text(item['nombre'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Estado: ${item['estado_operativo']}'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 15),
      ),
    );
  }

  IconData _getIcon(String? tipo) {
    switch (tipo) {
      case 'HIDRONUCLEO': return Icons.water_drop;
      case 'DRON': return Icons.airplanemode_active;
      case 'REACTOR': return Icons.settings_input_component;
      default: return Icons.developer_board;
    }
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class VentanaChat extends StatefulWidget {
  const VentanaChat({super.key});

  @override
  State<VentanaChat> createState() => _VentanaChatState();
}

class _VentanaChatState extends State<VentanaChat> {
  final TextEditingController _controller = TextEditingController();

  void _enviarMensaje() async {
    if (_controller.text.isEmpty) return;
    final texto = _controller.text;
    _controller.clear();

    // INSERTAR MENSAJE EN SUPABASE
    await Supabase.instance.client.from('mensajes_agentes').insert({
      'remitente': 'JOSE',
      'contenido': texto,
      'agente_id': 'USUARIO'
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(15),
          child: Text("SISTEMA ALEJANDRÍA: CHAT EN VIVO", 
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent)),
        ),
        const Divider(),
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            // ESCUCHA ACTIVA DE MENSAJES
            stream: Supabase.instance.client
                .from('mensajes_agentes')
                .stream(primaryKey: ['id'])
                .order('creado_at', ascending: false), 
            builder: (context, snapshot) {
              if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              
              final msgs = snapshot.data!;
              return ListView.builder(
                reverse: true, // Para que los nuevos mensajes aparezcan abajo
                padding: const EdgeInsets.all(15),
                itemCount: msgs.length,
                itemBuilder: (context, index) {
                  final m = msgs[index];
                  bool esMio = m['remitente'].toString().toUpperCase() == 'JOSE';
                  
                  return Align(
                    alignment: esMio ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(12),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                      decoration: BoxDecoration(
                        color: esMio ? Colors.blueGrey[800] : Colors.green[900],
                        borderRadius: BorderRadius.circular(15).copyWith(
                          bottomRight: esMio ? const Radius.circular(0) : const Radius.circular(15),
                          bottomLeft: !esMio ? const Radius.circular(0) : const Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: esMio ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(m['remitente'], style: const TextStyle(fontSize: 10, color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text(m['contenido'], style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 15, left: 15, right: 15, top: 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Consultar a la IA...',
                    fillColor: Colors.white10,
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.greenAccent.shade700,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: _enviarMensaje,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}