import 'package:flutter/material.dart';
import 'package:proutvm/firebase/equipos.dart';
import 'package:proutvm/modelos/equipo.dart';
import 'package:proutvm/servicios/validadorSvc.dart';
import 'package:proutvm/controladores/utileriasCtrl.dart';
import 'package:proutvm/vistas/proyectos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proutvm/vistas/acceso.dart';

class equipos extends StatefulWidget {
  final String userId;

  equipos({required this.userId});

  @override
  _equiposState createState() => _equiposState();
}

class _equiposState extends State<equipos> {
  // Variables del formulario
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _descripcion = TextEditingController();
  final TextEditingController _organizacion = TextEditingController();

  final TextEditingController _codigo = TextEditingController();
  String? _errorText;

  final equiposTabla _equiposTabla = equiposTabla();

  // GlobalKey para el formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyFormu = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }



  void _mdlagregarEquipo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          decoration: BoxDecoration(
            /* color: Colors.white, */
            borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
          ),
          height: MediaQuery.of(context).size.height * 0.40,
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
                        'Agregar equipo',
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
                      'Consolida la base para realizar un gestor de tareas exitoso'),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextFormField(
                        controller: _nombre,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.people),
                          labelText: 'Nombre del equipo',
                          filled: true,
                          fillColor: const Color.fromARGB(255, 231, 231, 231),
                        ),
                        validator: Validadorsvc().validarNombreEquipo),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextFormField(
                      controller: _descripcion,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.abc),
                        labelText: 'Descripción breve',
                        filled: true,
                        fillColor: const Color.fromARGB(255, 231, 231, 231),
                      ),
                      validator: (value) =>
                          Validadorsvc().validarComboParrafo(value, 20),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextFormField(
                      controller: _organizacion,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.business_center_outlined),
                        labelText: 'Organización',
                        filled: true,
                        fillColor: const Color.fromARGB(255, 231, 231, 231),
                      ),
                      validator: (value) =>
                          Validadorsvc().validarComboParrafo(value, 3),
                    ),
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
              _formKeyFormu.currentState!.reset();
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
              agregarEquipo(); // Llamar al método de eliminación
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

  Future<void> _cargarDatosEquipo(String equipo_) async {
    // Leer usuario específico usando el userId
    Equipo? equipo = await _equiposTabla.verEquipo(equipo_);
    if (equipo != null) {
      try {
        // Actualizar los controles de texto con los valores desencriptados
        setState(() {
          _nombre.text = equipo.nombre;
          _descripcion.text = equipo.descripcion;
          _organizacion.text = equipo.organizacion;
          _mdlmodificarEquipo(equipo_);
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

  void _mdlmodificarEquipo(String equipo) {
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
                        'Modificar equipo',
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
                  Text('Id: ' + equipo),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextFormField(
                        controller: _nombre,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.people),
                          labelText: 'Nombre del equipo',
                          filled: true,
                          fillColor: const Color.fromARGB(255, 231, 231, 231),
                        ),
                        validator: Validadorsvc().validarNombreEquipo),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextFormField(
                      controller: _descripcion,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.abc),
                        labelText: 'Descripción breve',
                        filled: true,
                        fillColor: const Color.fromARGB(255, 231, 231, 231),
                      ),
                      validator: (value) =>
                          Validadorsvc().validarComboParrafo(value, 20),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextFormField(
                      controller: _organizacion,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.business_center_outlined),
                        labelText: 'Organización',
                        filled: true,
                        fillColor: const Color.fromARGB(255, 231, 231, 231),
                      ),
                      validator: (value) =>
                          Validadorsvc().validarComboParrafo(value, 3),
                    ),
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
              _modificarEquipo(equipo);
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

  void _mdlinfoEquipo(String equipo) async {
    Equipo? equipo_ = await _equiposTabla.verEquipo(equipo);

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
                        'Información',
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
                  Text('Id: ' + equipo),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.blue),
                    title: Text('Nombre del equipo'),
                    subtitle: Text(
                      equipo_?.nombre ?? 'Cargando...',
                    ),
                  ),
                  Divider(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ListTile(
                    leading: Icon(Icons.qr_code_rounded, color: Colors.blue),
                    title: Text('Código de equipo'),
                    subtitle: Text(
                      equipo_?.codigo ?? 'Cargando...',
                    ),
                  ),
                  Divider(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ListTile(
                    leading: Icon(Icons.work_outline, color: Colors.blue),
                    title: Text('Organización'),
                    subtitle: Text(
                      equipo_?.organizacion ?? 'Cargando...',
                    ),
                  ),
                  Divider(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ListTile(
                    leading: Icon(Icons.padding_sharp, color: Colors.blue),
                    title: Text('Descripción del equipo'),
                    subtitle: Text(
                      equipo_?.descripcion ?? 'Cargando...',
                    ),
                  ),
                  Divider(),
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
            },
            child: Row(
              mainAxisSize: MainAxisSize.min, // Ajustar al contenido
              children: [
                Icon(Icons.check_circle,
                    color: Colors.green[800]), // Icono de continuar
                SizedBox(width: 8), // Espacio entre el icono y el texto
                Text('Aceptar',
                    style: TextStyle(color: Colors.green[800], fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Modificar equipo
  Future<void> _modificarEquipo(String equipo_) async {
    if (_formKey.currentState!.validate()) {
      // Cargar la clave pública para cifrar los datos
      try {
        // Crear un objeto usuario con los datos cifrados
        Equipo equipo = Equipo(
            nombre: _nombre.text,
            descripcion: _descripcion.text,
            organizacion: _organizacion.text);

        // Actualizar el usuario en Firestore
        await _equiposTabla.actualizarEquipo(equipo, equipo_);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Datos actualizados con éxito')),
        );

        Navigator.pop(context); // Cerrar el diálogo
        reseteaFormulario(); // Llamar al método de reseteo del formulario
      } catch (e) {
        // Manejo de errores durante la actualización
        print('Error al actualizar los datos: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar los datos: $e')),
        );
      }
    }
  }

  //Modal para eliminar equipo
  void _mdleliminarEquipo(String equipo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                        'Eliminar equipo',
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
                      'Al eliminar al equipo, perderan los progresos, proyectos ¿Desea continuar?'),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Text('Id: ' + equipo),
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
              eliminarEquipo(equipo);
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

  // Eliminar equipo
  Future<void> eliminarEquipo(String equipo_) async {
    try {
      // Eliminar el usuario en Firestore
      await _equiposTabla.eliminarEquipo(equipo_);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Equipo eliminado con éxito')),
      );
      Navigator.pop(context); // Cerrar el diálogo
      reseteaFormulario(); // Llamar al método de reseteo del formulario
    } catch (e) {
      // Manejo de errores durante la eliminación
      print('Error al eliminar el equipo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el equipo: $e')),
      );
    }
  }

  Future<void> reseteaFormulario() async {
    _nombre.clear();
    _descripcion.clear();
    _organizacion.clear();
    _codigo.clear();
  }

  // Registro de equipo
  Future<void> agregarEquipo() async {
    if (_formKey.currentState!.validate()) {
      Equipo nuevoEquipo = Equipo(
          nombre: _nombre.text,
          descripcion: _descripcion.text,
          organizacion: _organizacion.text,
          miembros: [widget.userId],
          roles: [
            {widget.userId: 1}
          ],
          codigo: Utileriasctrl().generarCodigoAleatorio());

      await _equiposTabla.crearEquipo(context, nuevoEquipo);

      Navigator.pop(context); // Cerrar el diálogo
      reseteaFormulario(); // Llamar al método de reseteo del formulario
    }
  }

  void mdlUnirseEquipo() {
    _errorText = ""; // Restablecer errores antes de mostrar el modal.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
                ),
                height: MediaQuery.of(context).size.height * 0.30,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 4),
                            Text(
                              'Unirte a un equipo',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Text(
                            'Ingresa el código que se te compartió previamente por tu administrador'),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: TextFormField(
                            controller: _codigo,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.key),
                              labelText: 'Código de equipo',
                              errorText:
                                  _errorText!.isEmpty ? null : _errorText,
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 231, 231, 231),
                            ),
                            validator: (value) =>
                                Validadorsvc().validarCodigoEquipo(value),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Cerrar el diálogo
                    reseteaFormulario(); // Llamar al método de reseteo
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cancel, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Cancelar',
                          style: TextStyle(color: Colors.red, fontSize: 18)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await unirseEquipo((errorMessage) {
                      setModalState(() {
                        _errorText =
                            errorMessage; // Actualizar el mensaje de error.
                      });
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green[800]),
                      SizedBox(width: 8),
                      Text('Continuar',
                          style: TextStyle(
                              color: Colors.green[800], fontSize: 18)),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      reseteaFormularioequipo(); // Asegurarse de resetear al cerrar el modal.
    });
  }

  Future<void> unirseEquipo(Function(String) actualizarError) async {
    if (_formKey.currentState!.validate()) {
      final codigo = _codigo.text;

      try {
        final error = await _equiposTabla.verificarExistenciaEquipo(codigo);
        if (error) {
          await _equiposTabla.unirseAEquipo(codigo, widget.userId, context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Te has unido con éxito a este equipo')),
          );

          Navigator.pop(context); // Cerrar el diálogo si todo está bien.
          reseteaFormulario(); // Resetea el formulario al éxito.
        } else {
          actualizarError("Código inválido");
        }
      } catch (e) {
        print("Error al intentar unirse al equipo: $e");
        actualizarError("Ocurrió un error inesperado. Intenta nuevamente.");
      }
    }
  }

  void reseteaFormularioequipo() {
    // Reinicia el estado del formulario
    _formKey.currentState?.reset();
    _codigo.clear(); // Limpia el texto del controlador
    _errorText = ""; // Limpia el mensaje de error Limpia el mensaje de error
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false, // Evita que el usuario retroceda
        child: Scaffold(
            resizeToAvoidBottomInset:
                false, // Esto evitará que el teclado cubra el contenido
            appBar: AppBar(
              title: Text(
                'Mis equipos',
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
                  icon: Icon(Icons.add_circle_outline_sharp),
                  onPressed: () {
                    _mdlagregarEquipo();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add_link_rounded),
                  onPressed: () {
                    mdlUnirseEquipo();
                  },
                ),
              ],
            ),
            body: SafeArea(
                child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                // Hacemos el contenido desplazable
                child: Column(
                  children: [
                    StreamBuilder<List<Equipo>>(
                      /*  future: listarEquipos(), */
                      stream: _equiposTabla
                          .verEquipos_(widget.userId), // Escucha el stream
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('No tienes equipos.'));
                        } else {
                          var equiposList = snapshot.data!;
                          return ListView.builder(
                            shrinkWrap:
                                true, // Para evitar que ocupe todo el espacio
                            physics:
                                NeverScrollableScrollPhysics(), // Evita el desplazamiento dentro del ListView
                            itemCount: equiposList.length,
                            itemBuilder: (context, index) {
                              var equipo = equiposList[index];
                              return InkWell(
                                onTap: () {
                                  // Acción al hacer clic en la tarjeta
                                  print('Tarjeta clickeada: ${equipo.id}');
                                  // Ejemplo: Navegar a otra página
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => DetalleEquipoPage(equipo: equipo)));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              proyectos(proId: equipo.id!)));
                                },
                                child: Card(
                                  elevation: 4,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.people,
                                                size: 32, color: Colors.blue),
                                            SizedBox(width: 8),
                                            Text(
                                              equipo.nombre,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                Text('Miembros',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey)),
                                                Text(
                                                    equipo.miembros!.length
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton.icon(
                                              onPressed: () {
                                                // Acción para eliminar
                                                print('Información de equipo');
                                                /*   _mdleliminarEquipo(equipo.id!); */
                                                _mdlinfoEquipo(equipo.id!);
                                              },
                                              icon: Icon(Icons.info_outline,
                                                  color: Colors.blue),
                                              label: Text('Info',
                                                  style: TextStyle(
                                                      color: Colors.blue)),
                                            ),
                                            TextButton.icon(
                                              onPressed: () {
                                                // Acción para editar
                                                print('Editar');
                                                _cargarDatosEquipo(equipo.id!);
                                              },
                                              icon: Icon(Icons.edit,
                                                  color: Colors.blue),
                                              label: Text('Editar',
                                                  style: TextStyle(
                                                      color: Colors.blue)),
                                            ),
                                            TextButton.icon(
                                              onPressed: () {
                                                // Acción para eliminar
                                                print('Eliminar');
                                                _mdleliminarEquipo(equipo.id!);
                                              },
                                              icon: Icon(Icons.delete,
                                                  color: Colors.red),
                                              label: Text('Eliminar',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ))));
  }
}
