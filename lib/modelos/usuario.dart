class Usuario {
  final String nombre;
  final String correo;
  final String rutaImagen;
 /*  final String usuario; */

  Usuario({ 
    required this.correo, 
    required this.nombre,
    required this.rutaImagen,
   /*  required this.usuario */
  });

  
  // Método para convertir un documento Firestore en un objeto Usuario
  factory Usuario.fromFirestore(Map<String, dynamic> data, String id) {
    return Usuario(
      nombre: data['nombre'],
      correo: data['correo'],
      rutaImagen: data['rutaImagen'],
     /*  usuario: data['usuario'] */
    );
  }

  // Método para convertir un objeto Usuario en un mapa para Firestore
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'correo': correo,
      'rutaImagen': rutaImagen,
    /*   'usuario': usuario */
    };
  }
  
  // Convertir un Map a un objeto Usuario
  factory Usuario.fromMap(Map<String, dynamic> data) {
    return Usuario(
      nombre: data['nombre'] ?? '',
      correo: data['correo'] ?? '',
      rutaImagen: data['rutaImagen'] ?? '',
    );
  }

  
}




