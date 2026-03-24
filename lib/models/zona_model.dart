class ZonaCultivo {
  final int id;
  final String variedad;
  final double ph;
  final double ce;
  final int incidenciaPlaga;
  final String estado;

  ZonaCultivo({
    required this.id,
    this.variedad = '',
    this.ph = 0.0,
    this.ce = 0.0,
    this.incidenciaPlaga = 0,
    this.estado = 'Limpio',
  });

  // Esto permite convertir lo que viene de Supabase a un objeto de Flutter
  factory ZonaCultivo.fromMap(Map<String, dynamic> map) {
    return ZonaCultivo(
      id: map['zona_id'],
      variedad: map['variedad'] ?? 'Sin Siembra',
      ph: (map['ph_salida_real'] ?? 0.0).toDouble(),
      ce: (map['ce_salida_real'] ?? 0.0).toDouble(),
      incidenciaPlaga: map['incidencia_plaga_pct'] ?? 0,
      estado: map['estado_bioseguridad'] ?? 'Limpio',
    );
  }
}