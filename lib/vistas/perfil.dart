import 'package:flutter/material.dart';
import 'package:proutvm/firebase/usuarios.dart';
import 'package:proutvm/modelos/usuario.dart';
import 'package:proutvm/servicios/encriptacionSvc.dart';
import 'package:proutvm/servicios/validadorSvc.dart';
import 'package:proutvm/vistas/acceso.dart';

class perfilUsuario extends StatefulWidget {
  final String userId;

  perfilUsuario({required this.userId});

  @override
  _perfilUsuarioState createState() => _perfilUsuarioState();
}

class _perfilUsuarioState extends State<perfilUsuario> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final TextEditingController _correoCmb = TextEditingController();

  final usuariosTabla _usuariosTabla = usuariosTabla();

  // GlobalKey para el formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String _errorMessage = '';

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Leer usuario específico usando el userId
    Usuario? usuario = await _usuariosTabla.leerUsuario(widget.userId);
    if (usuario != null) {
      try {
        final nombre_dec = await EncriptacionSvc().desencriptar(usuario.nombre);
        final correo_dec = await EncriptacionSvc().desencriptar(usuario.correo);

        // Actualizar los controles de texto con los valores desencriptados
        setState(() {
          _nameController.text = nombre_dec;
          _emailController.text = correo_dec;
        });
      } catch (e) {
        // Manejo de errores durante la desencriptación
        print('Error al desencriptar: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar los datos del usuario $e')),
        );
      }
    } else {
      // Manejo de error si el usuario no fue encontrado
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario no encontrado')),
      );
    }
  }

  Future<void> _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      // Cargar la clave pública para cifrar los datos
      try {
        // Crear un objeto usuario con los datos cifrados
        Usuario usuarioActualizado = Usuario(
            nombre: await EncriptacionSvc().encriptar(_nameController.text),
            correo: await EncriptacionSvc().encriptar(_emailController.text),
            rutaImagen: '');

        // Actualizar el usuario en Firestore
        await _usuariosTabla.actualizarUsuario(
            usuarioActualizado, widget.userId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Datos actualizados con éxito')),
        );
      } catch (e) {
        // Manejo de errores durante la actualización
        print('Error al actualizar los datos: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar los datos: $e')),
        );
      }
    }
  }

  Future<void> _eliminarUsuario() async {
    try {
      await _usuariosTabla.eliminarUsuario(widget.userId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario eliminado con éxito')),
      );
      
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => accesoPagina()), // Redirige al login después de cerrar sesión
    );

    } catch (e) {
      print('Error al eliminar el usuario: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el usuario: $e')),
      );
    }
  }

   void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de que deseas eliminar esta cuenta? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cerrar el diálogo
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar el diálogo
              _eliminarUsuario(); // Llamar al método de eliminación
            },
            child: Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
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
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  height: MediaQuery.of(context).size.height * 0.85,
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Form(
                      // Envolvemos los campos en un Form
                      key: _formKey, // Asociamos la key del formulario
                      child: Column(
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                          Text(
                            'Perfil',
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
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          SizedBox(
                            width: 280,
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: 'Nombre completo',
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 231, 231, 231),
                              ),
                              validator: Validadorsvc().validarNombre,
                              enabled: _isEditing,
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          SizedBox(
                            width: 280,
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                labelText: 'Correo electrónico',
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 231, 231, 231),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: Validadorsvc().validarCorreo,
                              enabled: _isEditing,
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          if (_isLoading) CircularProgressIndicator(),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          // Cambia el botón para alternar entre editar y guardar
                          SizedBox(
                            width: 200,
                            child: TextButton(
                              onPressed: () {
                                if (_isEditing) {
                                  // Si estamos en modo edición y se presiona "Guardar", valida el formulario
                                  if (_formKey.currentState!.validate()) {
                                    // Actualiza los datos
                                    _updateUserData();
                                    setState(() {
                                      _isEditing =
                                          false; // Cambia a modo no edición después de guardar
                                    });
                                  } else {
                                    // Si el formulario no es válido, muestra un mensaje
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Por favor corrige los errores antes de guardar.')),
                                    );
                                  }
                                } else {
                                  // Si estamos en modo no edición, simplemente activa el modo de edición
                                  setState(() {
                                    _isEditing = true;
                                  });
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(width: 8),
                                  Text(
                                    _isEditing ? 'Guardar' : 'Modificar',
                                    style: const TextStyle(
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
                          // Botón para eliminar el usuario
                          SizedBox(
                            width: 200,
                            child: TextButton(
                              onPressed: _confirmDelete,
                              child: Text(
                                'Eliminar Usuario',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
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
