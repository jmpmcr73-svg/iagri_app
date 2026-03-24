class BitacoraRegistro {
  final int id;
  final int zonaId;
  final String tipo; // Riego, Foliar, Desinfección
  final String producto;
  final double cantidad;
  final String unidad;
  final double costo;
  final DateTime fecha;

  BitacoraRegistro({
    required this.id,
    required this.zonaId,
    required this.tipo,
    required this.producto,
    required this.cantidad,
    required this.unidad,
    required this.costo,
    required this.fecha,
  });

  factory BitacoraRegistro.fromMap(Map<String, dynamic> map) {
    return BitacoraRegistro(
      id: map['id'],
      zonaId: map['zona_id'],
      tipo: map['tipo_aplicacion'] ?? 'N/A',
      producto: map['producto'] ?? '',
      cantidad: (map['cantidad'] ?? 0.0).toDouble(),
      unidad: map['unidad'] ?? 'kg',
      costo: (map['costo_estimado'] ?? 0.0).toDouble(),
      fecha: DateTime.parse(map['fecha_aplicacion']),
    );
  }
}