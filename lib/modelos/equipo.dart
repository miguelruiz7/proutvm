class Equipo {
  final String? id;
  final String nombre;
  final String descripcion;
  final String organizacion;
  final List<dynamic>? miembros;
  final List<dynamic>? roles; 
  final String? codigo;

  Equipo({ 
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.organizacion,
    this.miembros, // Ahora es opcional
    this.roles,
    this.codigo,
  });

  // Método para convertir un documento Firestore en un objeto Equipo
  factory Equipo.fromFirestore(Map<String, dynamic> data, String id) {
    return Equipo(
      id : id,
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      organizacion: data['organizacion'] ?? '',
      miembros: data['miembros'] as List<dynamic>?, // Convertir dinámicamente
      roles: data['roles'] as List<dynamic>?, // Convertir dinámicamente
      codigo: data['codigo'] ?? '',
    );

  }

  // Método para convertir un objeto Equipo en un mapa para Firestore
 Map<String, dynamic> toMap() {
  final Map<String, dynamic> data = {};

  // Solo agregar los campos que no son null
  if (nombre != null) data['nombre'] = nombre;
  if (descripcion != null) data['descripcion'] = descripcion;
  if (organizacion != null) data['organizacion'] = organizacion;
  if (miembros != null) data['miembros'] = miembros ?? [];
  if (roles != null) data['roles'] = roles ?? [];
  if (codigo != null) data['codigo'] = codigo;

  return data;
}


  // Convertir un Map a un objeto Equipo (Individual)
  factory Equipo.fromMap(Map<String, dynamic> data) {
    return Equipo(
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      organizacion: data['organizacion'] ?? '',
      miembros: data['miembros'] as List<dynamic>?, // Convertir dinámicamente
      roles: data['roles'] as List<dynamic>?,
      codigo: data['codigo'] ?? '',
    );
  }
}
