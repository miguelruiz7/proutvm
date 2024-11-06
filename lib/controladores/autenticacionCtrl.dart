import 'package:firebase_auth/firebase_auth.dart';
import 'package:proutvm/servicios/autenticacionSvc.dart';

class autenticacionCtrl {
  final autenticacionSvc _authService = autenticacionSvc();

  Future<User?> login(String email, String password) async {
    return await _authService.login(email, password);
  }

  Future<User?> registro(String email, String password) async {
    return await _authService.registro(email, password);
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  User? get currentUser => _authService.currentUser;
}
