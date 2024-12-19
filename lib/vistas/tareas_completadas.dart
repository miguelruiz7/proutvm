import 'package:flutter/material.dart';
import 'package:proutvm/firebase/tareas.dart';
import 'package:proutvm/servicios/validadorSvc.dart';
import 'package:proutvm/modelos/tarea.dart';

class tareasCompletadas extends StatefulWidget {
  final String proId;

  tareasCompletadas({required this.proId});

  @override
  _tareasCompletadasState createState() => _tareasCompletadasState();
}

class _tareasCompletadasState extends State<tareasCompletadas> {
  final tareasTabla _tareasTabla = tareasTabla();

  // Variables del formulario
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _descripcion = TextEditingController();
  final TextEditingController _fechaInicio = TextEditingController();
  final TextEditingController _fechaFinalizacion = TextEditingController();

  final GlobalKey<FormState> _formularioTareas = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  void _mdlagregarTarea() {
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
              key: _formularioTareas,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Ícono a la izquierda
                      SizedBox(width: 4), // Espacio entre el ícono y el texto
                      Text(
                        'Agregar tarea',
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
                      'Aquí crearás todo tu proceso para llevar a cabo el tarea'),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextFormField(
                        controller: _nombre,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.library_books),
                          labelText: 'Nombre del tarea',
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
                    child: GestureDetector(
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          _fechaInicio.text = selectedDate
                              .toString(); // Guarda la fecha en el controlador
                        }
                      },
                      child: AbsorbPointer(
                        // Evita que el teclado se muestre
                        child: TextFormField(
                          controller: _fechaInicio,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today),
                            labelText: 'Selecciona la fecha de inicio',
                            filled: true,
                            fillColor: const Color.fromARGB(255, 231, 231, 231),
                          ),
                          /* validator: (value) =>
                              Validadorsvc().validarComboParrafo(value, 20), */
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: GestureDetector(
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          _fechaFinalizacion.text = selectedDate
                              .toString(); // Guarda la fecha en el controlador
                        }
                      },
                      child: AbsorbPointer(
                        // Evita que el teclado se muestre
                        child: TextFormField(
                          controller: _fechaFinalizacion,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today),
                            labelText: 'Selecciona la fecha de finalización',
                            filled: true,
                            fillColor: const Color.fromARGB(255, 231, 231, 231),
                          ),
                          /*  validator: (value) =>
                              Validadorsvc().validarComboParrafo(value, 20), */
                        ),
                      ),
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
              _formularioTareas.currentState!.reset();
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
            onPressed: () async {
              await agregarTarea(); // Llamar al método de eliminación
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

  //Agregar tarea
  Future<void> agregarTarea() async {
    // Validar el formulario
    if (_formularioTareas.currentState!.validate()) {
      Tarea nuevaTarea = Tarea(
        nombre: _nombre.text,
        descripcion: _descripcion.text,
        fechaInicio:
            DateTime.parse(_fechaInicio.text), // Convierte el texto a DateTime
        fechaFinalizacion: DateTime.parse(
            _fechaFinalizacion.text), // Convierte el texto a DateTime
      );

      await _tareasTabla.crearTarea(context, nuevaTarea, widget.proId);
      Navigator.pop(context); // Cerrar el diálogo
      reseteaFormulario(); // Llamar al método de reseteo del formulario
    }
  }

  void _mdlinfotarea(String tarea) async {
    Tarea? tarea_ = await _tareasTabla.verTarea(widget.proId, tarea);

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
              key: _formularioTareas,
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
                  Text('Id: ' + tarea),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ListTile(
                    leading: Icon(Icons.lightbulb_circle, color: Colors.blue),
                    title: Text('Nombre del tarea'),
                    subtitle: Text(
                      tarea_?.nombre ?? 'Cargando...',
                    ),
                  ),
                  Divider(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ListTile(
                    leading: Icon(Icons.padding_sharp, color: Colors.blue),
                    title: Text('Descripción del tarea'),
                    subtitle: Text(
                      tarea_?.descripcion ?? 'Cargando...',
                    ),
                  ),
                  Divider(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ListTile(
                    leading: Icon(Icons.calendar_month, color: Colors.blue),
                    title: Text('Inicio del tarea'),
                    subtitle:
                        Text(tarea_?.fechaInicio?.toString() ?? 'Cargando...'),
                  ),
                  Divider(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ListTile(
                    leading: Icon(Icons.calendar_month, color: Colors.blue),
                    title: Text('Fin del tarea'),
                    subtitle: Text(
                      tarea_?.fechaFinalizacion?.toString() ?? 'Cargando...',
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

  //Modal para eliminar equipo
  void _mdleliminarTarea(String tarea) {
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
              key: _formularioTareas,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Ícono a la izquierda
                      SizedBox(width: 4), // Espacio entre el ícono y el texto
                      Text(
                        'Eliminar tarea',
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
                  Text('Id: ' + tarea),
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
              eliminarTarea(tarea);
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
  Future<void> eliminarTarea(String tarea_) async {
    try {
      // Eliminar el usuario en Firestore
      await _tareasTabla.eliminarTarea(widget.proId, tarea_);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tarea eliminada con éxito')),
      );
      Navigator.pop(context); // Cerrar el diálogo
      reseteaFormulario(); // Llamar al método de reseteo del formulario
    } catch (e) {
      // Manejo de errores durante la eliminación
      print('Error al eliminar la tarea: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la tarea: $e')),
      );
    }
  }


  Future<void> _cargarDatosTarea(String tarea_) async {
    // Leer usuario específico usando el userId
    Tarea? tarea = await _tareasTabla.verTarea( widget.proId, tarea_);
    if (tarea != null) {
      try {
        // Actualizar los controles de texto con los valores desencriptados
        setState(() {
          _nombre.text = tarea.nombre;
          _descripcion.text = tarea.descripcion;
          _fechaInicio.text = tarea.fechaInicio?.toString()?? '';
          _fechaFinalizacion.text = tarea.fechaFinalizacion?.toString()?? '';
           _mdlmodificarTarea(tarea_);
  
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

void _mdlmodificarTarea(tarea) {
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
              key: _formularioTareas,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Ícono a la izquierda
                      SizedBox(width: 4), // Espacio entre el ícono y el texto
                      Text(
                        'Modificar tarea',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 27,
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
               
                 
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextFormField(
                        controller: _nombre,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lightbulb_circle),
                          labelText: 'Nombre de la tarea',
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
                    child: GestureDetector(
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          _fechaInicio.text = selectedDate
                              .toString(); // Guarda la fecha en el controlador
                        }
                      },
                      child: AbsorbPointer(
                        // Evita que el teclado se muestre
                        child: TextFormField(
                          controller: _fechaInicio,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today),
                            labelText: 'Selecciona la fecha de inicio',
                            filled: true,
                            fillColor: const Color.fromARGB(255, 231, 231, 231),
                          ),
                          /* validator: (value) =>
                              Validadorsvc().validarComboParrafo(value, 20), */
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: GestureDetector(
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          _fechaFinalizacion.text = selectedDate
                              .toString(); // Guarda la fecha en el controlador
                        }
                      },
                      child: AbsorbPointer(
                        // Evita que el teclado se muestre
                        child: TextFormField(
                          controller: _fechaFinalizacion,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today),
                            labelText: 'Selecciona la fecha de finalización',
                            filled: true,
                            fillColor: const Color.fromARGB(255, 231, 231, 231),
                          ),
                         /*  validator: (value) =>
                              Validadorsvc().validarComboParrafo(value, 20), */
                        ),
                      ),
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
              _formularioTareas.currentState!.reset();
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
            onPressed: () async {
             await  _modificarTarea(tarea);  // Llamar al método de eliminación
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

    // Modificar equipo
  Future<void> _modificarTarea(String tarea_) async {
    if (_formularioTareas.currentState!.validate()) {
      // Cargar la clave pública para cifrar los datos
      try {
        // Crear un objeto usuario con los datos cifrados
        Tarea tarea = Tarea(
            nombre: _nombre.text,
            descripcion: _descripcion.text,
            fechaInicio: DateTime.parse(_fechaInicio.text),
            fechaFinalizacion: DateTime.parse(_fechaFinalizacion.text),
        );
        // Actualizar el usuario en Firestore
        await _tareasTabla.actualizarTarea(widget.proId, tarea, tarea_);
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


  Future<void> reseteaFormulario() async {
    _nombre.clear();
    _descripcion.clear();
    _fechaInicio.clear();
    _fechaFinalizacion.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Mis tareas',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight:
                  FontWeight.bold, // Esto hará que el texto esté en negrita
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add_circle_outline_sharp),
              onPressed: () {
                _mdlagregarTarea();
              },
            ),
          ],
           leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.pop(context);
    },
  ),
        ),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            // Hacemos el contenido desplazable
            child: Column(
              children: [
                StreamBuilder<List<Tarea>>(
                  /*  future: listartareas(), */
                  stream:
                      _tareasTabla.verTareasCompletadas(widget.proId), // Escucha el stream
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No tienes tareas completadas aun.'));
                    } else {
                      var tareasList = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap:
                            true, 
                        physics:
                            NeverScrollableScrollPhysics(), // Evita el desplazamiento dentro del ListView
                        itemCount: tareasList.length,
                        itemBuilder: (context, index) {
                          var tarea = tareasList[index];
                          return InkWell(
                            onTap: () {
                              // Acción al hacer clic en la tarjeta
                              print('Tarjeta clickeada: ${tarea.id}');
                              // Ejemplo: Navegar a otra página
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => DetalletareaPage(tarea: tarea)));
                              /* Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          tareas(proId: tarea.id!))); */
                            },
                            child: Card(
                              elevation: 4,
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.lightbulb_circle,
                                            size: 32, color: Colors.blue),
                                        SizedBox(width: 8),
                                        Text(
                                          tarea.nombre,
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
                                            /* Text('Miembros',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey)),
                                            Text("?",
                                                /*   tarea.miembros!.length
                                                        .toString(), */
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)), */
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () {
                                            // Acción para eliminar
                                            print('Información de tarea');
                                            _mdlinfotarea(tarea.id!);
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
                                             _cargarDatosTarea(tarea.id!);
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

                                            _mdleliminarTarea(tarea.id!);
                                          },
                                          icon: Icon(Icons.delete,
                                              color: Colors.red),
                                          label: Text('Eliminar',
                                              style:
                                                  TextStyle(color: Colors.red)),
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
        )));
  }
}
