import 'package:flutter/material.dart';

class AgenteCard extends StatelessWidget {
  // Añade esta clase al final de tu main.dart
class ChatAgentes extends StatefulWidget {
  const ChatAgentes({super.key});

  @override
  State<ChatAgentes> createState() => _ChatAgentesState();
}

class _ChatAgentesState extends State<ChatAgentes> {
  final TextEditingController _controller = TextEditingController();

  void _enviarMensaje() async {
    if (_controller.text.isEmpty) return;
    
    await Supabase.instance.client.from('mensajes_agentes').insert({
      'remitente': 'JOSE',
      'contenido': _controller.text,
      'agente_id': 'USUARIO'
    });
    
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: Supabase.instance.client
                .from('mensajes_agentes')
                .stream(primaryKey: ['id'])
                .order('creado_at', descending: true),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              final mensajes = snapshot.data!;
              return ListView.builder(
                reverse: true, // Para que el chat suba como WhatsApp
                itemCount: mensajes.length,
                itemBuilder: (context, index) {
                  final m = mensajes[index];
                  bool esUsuario = m['remitente'] == 'JOSE';
                  return Align(
                    alignment: esUsuario ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: esUsuario ? Colors.blueGrey : Colors.green.shade900,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text("${m['remitente']}: ${m['contenido']}"),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(hintText: 'Escribe a los agentes...'))),
              IconButton(icon: const Icon(Icons.send, color: Colors.green), onPressed: _enviarMensaje),
            ],
          ),
        ),
      ],
    );
  }
}
  @override
  Widget build(BuildContext context) {
     return Card(child: Text("Datos del Agente"));
  }
}