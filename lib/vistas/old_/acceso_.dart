import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  // Combos de texto donde se capturan las credenciales del usuario.
  final TextEditingController _correoCmb = TextEditingController();
  final TextEditingController _contrasenaCmb = TextEditingController();

 // Cargar los estados de carga mientra se realiza una acción de inicio de sesión.
  final bool _isLoading = false;
  
  final Function(String, String) onLogin;

  LoginView({required this.onLogin});

  @override
    Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Evita que el usuario retroceda
      child: Scaffold(
        backgroundColor: Colors.blue,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  height: MediaQuery.of(context).size.height * 0.45,
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        Text(
                          '¡Hola!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 36,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        SizedBox(
                          width: 280,
                          child: TextField(
                            controller: _correoCmb,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: 'Correo electrónico',
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 231, 231, 231),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        SizedBox(
                          width: 280,
                          child: TextField(
                            controller: _contrasenaCmb,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.key),
                              labelText: 'Contraseña',
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 231, 231, 231),
                            ),
                            obscureText: true,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        if (_isLoading) CircularProgressIndicator(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        SizedBox(
                          width: 200,
                          child: TextButton(
                             onPressed: () {
                              String email = _correoCmb.text.trim();
                              String password = _contrasenaCmb.text.trim();
                              onLogin(email, password); // Llamada al controlador
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                SizedBox(width: 8),
                                Text(
                                  'Iniciar sesión',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        SizedBox(
                          width: 200,
                          child: TextButton(
                            onPressed: () {
                             /*  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => registroPagina())); */
                            },
                            child: const Text(
                              'Regístrate',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
 
}
