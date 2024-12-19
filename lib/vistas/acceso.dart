import 'package:flutter/material.dart';
import 'package:proutvm/controladores/autenticacionCtrl.dart';
import 'package:proutvm/main.dart';
import 'package:proutvm/servicios/encriptacionSvc.dart';
import 'package:proutvm/servicios/validadorSvc.dart';
import 'package:proutvm/vistas/registro.dart';
import 'package:proutvm/modelos/usuario.dart';
import 'package:proutvm/firebase/usuarios.dart';



class accesoPagina extends StatefulWidget {
  const accesoPagina({super.key});

  @override
  State<accesoPagina> createState() => _accesoPaginaState();
}

class _accesoPaginaState extends State<accesoPagina> {

  final autenticacionCtrl _autenticacionCtrl = autenticacionCtrl();
    final usuariosTabla _usuariosTabla = usuariosTabla();

  // Controladores de texto
  final TextEditingController _correoCmb = TextEditingController();
  final TextEditingController _contrasenaCmb = TextEditingController();

  // GlobalKey para el formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String _errorMessage = '';

Future<void> _login() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final email = _correoCmb.text.trim();
    final password = _contrasenaCmb.text.trim();

    final user = await _autenticacionCtrl.login(email, password);

    if (user != null) {
      // Successful login, navigate to main screen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyApp()));
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Credenciales inválidas';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage)),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Evita que el usuario retroceda
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
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  height: MediaQuery.of(context).size.height * 0.45,
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    child: Form( // Envolvemos los campos en un Form
                      key: _formKey, // Asociamos la key del formulario
                      child: Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: TextFormField(
                              controller: _correoCmb,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                labelText: 'Correo electrónico',
                                filled: true,
                                fillColor: const Color.fromARGB(255, 231, 231, 231),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: Validadorsvc().validarCorreo,
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: TextFormField(
                              validator: Validadorsvc().validarContrasena,
                              controller: _contrasenaCmb,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.key),
                                labelText: 'Contraseña',
                                filled: true,
                                fillColor: const Color.fromARGB(255, 231, 231, 231),
                              ),
                              obscureText: true,
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          if (_isLoading) CircularProgressIndicator(),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          SizedBox(
                            width: 200,
                            child: TextButton(
                              onPressed: _isLoading ? null : _login,
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
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          SizedBox(
   width: MediaQuery.of(context).size.width * 0.65,
  
  child: ElevatedButton.icon(
    onPressed: () async {
      final user = await _autenticacionCtrl.signInWithGoogle();
      if (user != null) {
        // Navega a la pantalla principal
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => MyApp()),
        );

        // Crear un objeto Usuario
        final usuario = Usuario(
          nombre: await EncriptacionSvc().encriptar(user.user?.displayName ?? ''),
          correo: await EncriptacionSvc().encriptar(user.user?.email ?? ''),
        );

        _usuariosTabla.crearUsuario(usuario, user.user!.uid);

      } else {
        // Mostrar un mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo iniciar sesión con Google')),
        );
      }
    },
    icon: Image.asset(
      'assets/img/google.png', // Asegúrate de incluir este archivo en tus assets
      height: 24,
      
    ),
    label: Text(
      'Iniciar sesión con Google',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black54,
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey), // Bordes estilo Google
      ),
      padding: EdgeInsets.symmetric(vertical: 12),
    ),
  ),
),

                          SizedBox(
                            width: 200,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => registroPagina()));
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
