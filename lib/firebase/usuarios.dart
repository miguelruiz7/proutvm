import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proutvm/modelos/usuario.dart';

class usuariosTabla {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Crear usuario
  Future<void> crearUsuario(Usuario usuario, String identificadorUsuario) async {
    await _firestore
        .collection('usuarios')
        .doc(identificadorUsuario) // Usa el uid del usuario como id del documento
        .set(usuario.toMap()); // Convierte el objeto Usuario a un mapa de datos
  }

  // Leer un usuario específico
  Future<Usuario?> leerUsuario(String identificadorUsuario) async {
    try {
      final docSnapshot = await _firestore.collection('usuarios').doc(identificadorUsuario).get();
      if (docSnapshot.exists) {
        // Si el documento existe, convierte los datos en un objeto Usuario
        return Usuario.fromMap(docSnapshot.data()!);
      } else {
        print('Usuario no encontrado');
        return null;
      }
    } catch (e) {
      print('Error al leer el usuario: $e');
      return null;
    }
  }

  // Actualizar un usuario
  Future<void> actualizarUsuario(Usuario usuario, String identificadorUsuario) async {
    await _firestore
       .collection('usuarios')
       .doc(identificadorUsuario)
       .update(usuario.toMap()); // Convierte el objeto Usuario a un mapa de datos
  }

  // Eliminar un usuario
  Future<void> eliminarUsuario(String identificadorUsuario) async {
    await _firestore
       .collection('usuarios')
       .doc(identificadorUsuario)
       .delete();

    // Eliminar de autenticación
      await FirebaseAuth.instance.currentUser?.delete();
      FirebaseAuth.instance.signOut();

  }

  
}
