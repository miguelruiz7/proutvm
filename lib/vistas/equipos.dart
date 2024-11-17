import 'package:flutter/material.dart';
import 'package:proutvm/firebase/usuarios.dart';
import 'package:proutvm/modelos/usuario.dart';
import 'package:proutvm/servicios/encriptacionSvc.dart';
import 'package:proutvm/servicios/validadorSvc.dart';
import 'package:proutvm/vistas/acceso.dart';

class equipos extends StatefulWidget {
  final String userId;

  equipos({required this.userId});

  @override
  _equiposState createState() => _equiposState();
}

class _equiposState extends State<equipos> {
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


    // Lista de los meses del año
    final List<String> meses = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];

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
                  height: MediaQuery.of(context).size.height * 0.90,
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                   child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                       AppBar(
                      title: Text(
                        'Mis equipos',
                        style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      actions: [
                       /*  IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              _isEditing = true;
                            });
                          },
                        ), */
                        IconButton(
                          icon: Icon(Icons.add_circle_outline_sharp),
                          onPressed: () {
                            _confirmDelete();
                          },
                        ),
                      ],
                    ),
                     SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                     
                   SizedBox(
 height: MediaQuery.of(context).size.height * 0.70, // Define una altura específica
  child: Center(
    child: ListView(
      shrinkWrap: true, // Ajusta el ListView al contenido
      children: [
        Card(
  elevation: 4, // Sombra de la tarjeta
  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.people, size: 32, color: Colors.blue), // Icono de personas
            SizedBox(width: 8), // Espacio entre icono y título
            Text(
              'Equipo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 16), // Espacio entre título e indicadores
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  'Miembros',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  '25', // Número de miembros
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Proyectos',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  '10', // Número de proyectos
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Tareas',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  '42', // Número de tareas
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16), // Espacio entre indicadores y barra
        // Espacio entre la barra y los botones
        Row(
          mainAxisAlignment: MainAxisAlignment.end, // Alinear los botones a la derecha
          children: [
            TextButton.icon(
              onPressed: () {
                // Acción para editar
                print('Editar');
              },
              icon: Icon(Icons.edit, color: Colors.blue),
              label: Text('Editar', style: TextStyle(color: Colors.blue)),
            ),
            TextButton.icon(
              onPressed: () {
                // Acción para eliminar
                print('Eliminar');
              },
              icon: Icon(Icons.delete, color: Colors.red),
              label: Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ],
    ),
  ),
)



       
        
      ],
    ),
  ),
)



                     
                    
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
