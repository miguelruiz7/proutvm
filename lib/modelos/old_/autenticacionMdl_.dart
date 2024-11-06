import 'package:firebase_auth/firebase_auth.dart';

class autenticacionMdl {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Método para iniciar sesión con correo y contraseña
  Future<User?> iniciarSesion(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      // Manejo de errores
      print('Error en el inicio de sesión: $e');
      return null;
    }
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
