import 'package:flutter/material.dart';
import 'package:proutvm/controladores/autenticacionCtrl.dart';
import 'package:proutvm/servicios/encriptacionSvc.dart';
import 'package:proutvm/servicios/validadorSvc.dart';
import 'package:proutvm/vistas/acceso.dart';
import 'package:proutvm/modelos/usuario.dart';
import 'package:proutvm/firebase/usuarios.dart';


class registroPagina extends StatefulWidget {
  const registroPagina({super.key});
  @override
  State<registroPagina> createState() => _registroPaginaState();
}

class _registroPaginaState extends State<registroPagina> {
  final autenticacionCtrl _autenticacionCtrl = autenticacionCtrl();
  final usuariosTabla _usuariosTabla = usuariosTabla();



  // Controladores de texto
  final TextEditingController _nombreCmb = TextEditingController();
  final TextEditingController _correoCmb = TextEditingController();
  final TextEditingController _contrasenaCmb = TextEditingController();
  final TextEditingController _contrasenaConfirmarCmb = TextEditingController();

  // GlobalKey para el formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    // Registro de usuario
  Future<void> registrarUsuario() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = await _autenticacionCtrl.registro(
            _correoCmb.text, _contrasenaCmb.text);
        
        if (user != null) {
       
       
          // Crear el objeto Usuario y guardarlo en Firestore
          Usuario nuevoUsuario = Usuario(
            nombre: await EncriptacionSvc().encriptar(_nombreCmb.text),
            correo: await EncriptacionSvc().encriptar(_correoCmb.text),
            rutaImagen: "", 
          );

          await _usuariosTabla.crearUsuario(nuevoUsuario, user.uid);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Usuario registrado con éxito')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => accesoPagina()), // Asegúrate de que AccesoPagina esté definida
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al registrar el usuario')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

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
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  height: MediaQuery.of(context).size.height * 0.65,
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey, // Asignamos el formulario a la clave
                      child: Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                          Text(
                            '¡Regístrate!',
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
                          // Campo de nombre
                          SizedBox(
                            width: 280,
                            child: TextFormField(
                              controller: _nombreCmb,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: 'Nombre completo',
                                filled: true,
                                fillColor: const Color.fromARGB(255, 231, 231, 231),
                              ),
                              validator: Validadorsvc().validarNombre,
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          // Campo de correo
                          SizedBox(
                            width: 280,
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
                          // Campo de contraseña
                          SizedBox(
                            width: 280,
                            child: TextFormField(
                              controller: _contrasenaCmb,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.key),
                                labelText: 'Contraseña',
                                filled: true,
                                fillColor: const Color.fromARGB(255, 231, 231, 231),
                              ),
                              obscureText: true,
                              validator: Validadorsvc().validarContrasena,
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          // Confirmación de contraseña
                          SizedBox(
                            width: 280,
                            child: TextFormField(
                              controller: _contrasenaConfirmarCmb,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.key),
                                labelText: 'Confirma la contraseña',
                                filled: true,
                                fillColor: const Color.fromARGB(255, 231, 231, 231),
                              ),
                              obscureText: true,
                              // In your widget:
                              validator: (value) => Validadorsvc().validarConfirmarContrasena(_contrasenaCmb.text, value),
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          // Botón de registro
                          SizedBox(
                            width: 200,
                            child: TextButton(
                              onPressed: () {
                                  registrarUsuario();
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  SizedBox(width: 8),
                                  Text(
                                    'Regístrate',
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
                          // Botón para iniciar sesión
                          SizedBox(
                            width: 200,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => accesoPagina(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Iniciar sesión',
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
