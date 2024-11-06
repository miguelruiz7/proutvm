import 'package:flutter/material.dart';
import 'package:proutvm/modelos/old_/autenticacionMdl_.dart';
/* import 'autenticacionCtrl.dart';
import '../vistas/acceso.dart';
 */
class autenticacionCtrl {
  final autenticacionMdl _authModel = autenticacionMdl();

  // Función que maneja el login
  void handleLogin(BuildContext context, String email, String password) async {
    final user = await _authModel.iniciarSesion(email, password);

    if (user != null) {
      // Si el login es exitoso, navega a la siguiente pantalla
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Muestra un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en el login, verifica tus credenciales')),
      );
    }
  }
}
