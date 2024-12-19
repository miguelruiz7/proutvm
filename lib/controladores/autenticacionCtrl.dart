import 'package:firebase_auth/firebase_auth.dart';
import 'package:proutvm/servicios/autenticacionSvc.dart';
import 'package:google_sign_in/google_sign_in.dart';


class autenticacionCtrl {
  final autenticacionSvc _authService = autenticacionSvc();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  

  Future<User?> login(String email, String password) async {
    return await _authService.login(email, password);
  }

  Future<User?> registro(String email, String password) async {
    return await _authService.registro(email, password);
  }

  Future<void> cerrarSesion() async {
    await _authService.logout();
  }


Future<String?> obtenerUsuario() async {
  final user = FirebaseAuth.instance.currentUser;
  return user?.uid;
}


Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // El usuario canceló el inicio de sesión
        return Future.error("El usuario canceló el inicio de sesión");
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("Error al iniciar sesión con Google: $e");
      return Future.error("Error al iniciar sesión con Google: $e");
    }
  }




 
/*   Future<void> verificarAutenticacion(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Redirige a la página de acceso con una transición suave
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => accesoPagina(),
        ),
      );
    }
  }
 */
 /*  Future<void> verificarAutenticacion() async {
  User? user = FirebaseAuth.instance.currentUser;
  
  print("Verificando usuario: ${user?.uid ?? 'No autenticado'}"); // Para ver el estado de autenticación
  
  if (user == null) {
    print("Usuario no autenticado, redirigiendo...");
   await navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (context) => accesoPagina()),
    );
  }
} */



  User? get currentUser => _authService.currentUser;


  
}
