import 'package:proutvm/servicios/encriptacionSvc.dart';
import 'package:proutvm/servicios/validadorSvc.dart';
import 'package:proutvm/firebase/usuarios.dart';
import 'package:proutvm/modelos/usuario.dart';

import 'package:flutter/material.dart';
import 'package:proutvm/controladores/autenticacionCtrl.dart'; 
import 'acceso.dart'; 
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:proutvm/firebase/almacenamiento/clases.dart';
import 'package:cached_network_image/cached_network_image.dart';


class perfil extends StatefulWidget {
  final String userId;

  perfil({required this.userId});


  @override
  _perfilState createState() => _perfilState();
}

class _perfilState extends State<perfil> {

  final autenticacionCtrl _authCtrl = autenticacionCtrl();
   final clasesAlmacenamiento _cla = clasesAlmacenamiento();
  
   final usuariosTabla _usuariosTabla = usuariosTabla();

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
     final TextEditingController _nombre = TextEditingController();
      final TextEditingController _correo = TextEditingController();


       File? _image;
  final ImagePicker _picker = ImagePicker();
   
   var _ideUsuario;
     var _nombreUsuario;
     var _correoUsuario;
     var _fotoUsuario;
     
       var ruta;


  @override
  void initState() {
    super.initState();
    _cargarDatos();

  }
  
  Future<void> _cerrarSesion() async {
    await _authCtrl.cerrarSesion();
   Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => accesoPagina(),
        ),
      );
  }

     void _mdlEliminarUsuario() {
    showDialog(
      context: context,
      builder: (context) =>  AlertDialog(
        content: Container(
          decoration: BoxDecoration(
            /* color: Colors.white, */
            borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
          ),
          height: MediaQuery.of(context).size.height * 0.15,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Ícono a la izquierda
                      SizedBox(width: 4), // Espacio entre el ícono y el texto
                      Text(
                        'Eliminar cuenta',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Text(
                      'Al eliminar tu cuenta, perderan los progresos, proyectos ¿Desea continuar?'),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                /*   Text('Id: ' + equipo), */
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              /* _formKey.currentState!.reset(); */
              reseteaFormulario(); // Llamar al método de reseteo del formulario
            }, // Cerrar el diálogo
            child: Row(
              mainAxisSize: MainAxisSize.min, // Ajustar al contenido
              children: [
                Icon(Icons.cancel, color: Colors.red), // Icono de cancelar
                SizedBox(width: 8), // Espacio entre el icono y el texto
                Text('Cancelar',
                    style: TextStyle(color: Colors.red, fontSize: 18)),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              _eliminarUsuario();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min, // Ajustar al contenido
              children: [
                Icon(Icons.check_circle,
                    color: Colors.green[800]), // Icono de continuar
                SizedBox(width: 8), // Espacio entre el icono y el texto
                Text('Continuar',
                    style: TextStyle(color: Colors.green[800], fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
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

   Future<void> obtenerImagen(Function setStateModal) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setStateModal(() {
        _image = File(pickedFile.path);
      });
    }
  }


  void _mdlmodificarUsuario() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          decoration: BoxDecoration(
            /* color: Colors.white, */
            borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
          ),
          height: MediaQuery.of(context).size.height * 0.35,
           width: MediaQuery.of(context).size.width * 0.85,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Ícono a la izquierda
                      SizedBox(width: 4), // Espacio entre el ícono y el texto
                      Text(
                        'Modificar perfil',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateModal) {
            return Column(
              
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_image != null)
                  Image.file(
                    _image!,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  )
                else
                  Text('No has seleccionado ninguna imagen'),
                SizedBox(height: 10),

                 TextButton(
            onPressed: () {
             obtenerImagen(setStateModal);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min, // Ajustar al contenido
              children: [
                Icon(Icons.upload_file,
                    color: Colors.blue[800]), // Icono de continuar
                SizedBox(width: 8), // Espacio entre el icono y el texto
                Text('Selecciona',
                    style: TextStyle(color: Colors.blue[800], fontSize: 18)),
              ],
            ),
          )
              ],
            );
          },
        ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  SizedBox(
                     width: MediaQuery.of(context).size.width * 0.85,
                    child: TextFormField(
                        controller: _nombre,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.people),
                          labelText: 'Nombre de pila',
                          filled: true,
                          fillColor: const Color.fromARGB(255, 231, 231, 231),
                        ),
                        validator: Validadorsvc().validarNombre),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              /* _formKey.currentState!.reset(); */
              _image = null;
             /*  reseteaFormulario();  */// Llamar al método de reseteo del formulario
            }, // Cerrar el diálogo
            child: Row(
              mainAxisSize: MainAxisSize.min, // Ajustar al contenido
              children: [
                Icon(Icons.cancel, color: Colors.red), // Icono de cancelar
                SizedBox(width: 8), // Espacio entre el icono y el texto
                Text('Cancelar',
                    style: TextStyle(color: Colors.red, fontSize: 18)),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              _modificarUsuario(widget.userId);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min, // Ajustar al contenido
              children: [
                Icon(Icons.check_circle,
                    color: Colors.green[800]), // Icono de continuar
                SizedBox(width: 8), // Espacio entre el icono y el texto
                Text('Continuar',
                    style: TextStyle(color: Colors.green[800], fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _modificarUsuario(usuario) async {
  if (_formKey.currentState!.validate()) {
      Usuario? usuario_ = await _usuariosTabla.leerUsuario(usuario);
      String ruta = usuario_!.rutaImagen; // Usar la ruta existente como valor predeterminado.

    if (_image != null) {
      try {
        // Subir la nueva imagen y actualizar la ruta
        ruta = await _cla.subirFotoPerfil(usuario, _image!);
      } catch (e) {
        // Manejar errores al subir la imagen
        print('Error al subir la imagen: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir la imagen: $e')),
        );
        return; // Salir si hay un error al subir la imagen
      }
    }

    try {
      // Crear un objeto usuario con los datos cifrados
      Usuario usuarioActualizado = Usuario(
        nombre: await EncriptacionSvc().encriptar(_nombre.text),
        correo: await EncriptacionSvc().encriptar(_correo.text),
        rutaImagen: ruta, // Usar la ruta actualizada o la existente
      );

      // Actualizar el usuario en Firestore
      await _usuariosTabla.actualizarUsuario(usuarioActualizado, usuario);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Datos actualizados con éxito')),
      );
      _cargarDatos();
      _image = null;
      Navigator.pop(context);
    } catch (e) {
      // Manejo de errores durante la actualización
      print('Error al actualizar los datos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar los datos: $e')),
      );
    }
  }
}


  Future<void> _cargarDatos() async {
    // Leer usuario específico usando el userId
    Usuario? usuario = await _usuariosTabla.leerUsuario(widget.userId);
    if (usuario != null) {
      try {
        final nombre_dec = await EncriptacionSvc().desencriptar(usuario.nombre);
        final correo_dec = await EncriptacionSvc().desencriptar(usuario.correo);
        final imagen_dec = usuario.rutaImagen;


        // Actualizar los controles de texto con los valores desencriptados
        setState(() {
            _ideUsuario = widget.userId;
             _nombre.text = nombre_dec;
             _correo.text = correo_dec;
            _nombreUsuario = nombre_dec;
            _correoUsuario = correo_dec;
            _fotoUsuario = imagen_dec;

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


    Future<void> reseteaFormulario() async {
    _nombre.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
            title: Text(
              'Mi perfil',
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight:
                    FontWeight.bold, // Esto hará que el texto esté en negrita
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _mdlmodificarUsuario();
                },
              ),
               IconButton(
                icon: Icon(Icons.exit_to_app_rounded),
                onPressed: () {
                  _cerrarSesion();
                },
              ),
            ],
          ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                
             
          CircleAvatar(
  radius: 60,
  backgroundImage: CachedNetworkImageProvider(
    _fotoUsuario ?? 'Cargando...'
  ),
  
),
    
                 SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                // Nombre del usuario
                Text(
                  _nombreUsuario ?? 'Cargando...',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                // Email del usuario
                Text(
                  _ideUsuario?? 'Cargando...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 30),
                // Campos de información personal
                ListTile(
                  leading: Icon(Icons.email, color: Colors.blue),
                  title: Text('Correo electrónico'),
                  subtitle: Text( _correoUsuario ?? 'Cargando...',),
                ),
                Divider(), SizedBox(height: MediaQuery.of(context).size.height * 0.01), SizedBox(height: 30),
                // Campos de información personal
                /* ListTile(
                  leading: Icon(Icons.email, color: Colors.blue),
                  title: Text('Imagen ruta'),
                  subtitle: Text( _fotoUsuario ?? 'Cargando...',),
                ),
                Divider(), */
                SizedBox(height: MediaQuery.of(context).size.height * 0.02), // Espaciado para evitar superposición con el botón
                Column( // Wrap buttons in a Row for horizontal placement
      mainAxisAlignment: MainAxisAlignment.end, // Space evenly
      children: [
      
              ElevatedButton(
                onPressed: _mdlEliminarUsuario,
                
                style: ElevatedButton.styleFrom(
                  
                backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  'Eliminar cuenta',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
        
      ],
    ),
              ],
            ),
          ),
          
         
          
        ],
      ),
      
    );
  }
}