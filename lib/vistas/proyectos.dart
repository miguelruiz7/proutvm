import 'package:flutter/material.dart';
import 'package:proutvm/firebase/proyectos.dart';
import 'package:proutvm/servicios/validadorSvc.dart';
import 'package:proutvm/controladores/utileriasCtrl.dart';
import 'package:proutvm/modelos/proyecto.dart';

class proyectos extends StatefulWidget {
  final String proId;

  proyectos({required this.proId});

  @override
  _proyectosState createState() => _proyectosState();
}
/*   
  const proyectos({super.key}); */

class _proyectosState extends State<proyectos> {
  final proyectosTabla _proyectosTabla = proyectosTabla();

  // Variables del formulario
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _descripcion = TextEditingController();
  final TextEditingController _fechaInicio = TextEditingController();
  final TextEditingController _fechaFinalizacion = TextEditingController();
  final TextEditingController _creacion = TextEditingController();

  final GlobalKey<FormState> _formularioProyectos = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  void _mdlagregarProyecto() {
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
              key: _formularioProyectos,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Ícono a la izquierda
                      SizedBox(width: 4), // Espacio entre el ícono y el texto
                      Text(
                        'Agregar proyecto',
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
                  Text('Inicia con algo nuevo, ten en mente tu idea'),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextFormField(
                        controller: _nombre,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lightbulb_circle),
                          labelText: 'Nombre del proyecto',
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
              _formularioProyectos.currentState!.reset();
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
             await  agregarProyecto();  // Llamar al método de eliminación
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

  //Agregar proyecto
  Future<void> agregarProyecto() async {
    // Validar el formulario
    if (_formularioProyectos.currentState!.validate()) {
     Proyecto nuevoProyecto = Proyecto(
  nombre: _nombre.text,
  descripcion: _descripcion.text,
  creacion: DateTime.parse(_fechaInicio.text), // Convierte el texto a DateTime
  fechaInicio: DateTime.parse(_fechaInicio.text), // Convierte el texto a DateTime
  fechaFinalizacion: DateTime.parse(_fechaFinalizacion.text), // Convierte el texto a DateTime
);
         

      await _proyectosTabla.crearProyecto(context, nuevoProyecto, widget.proId);

      Navigator.pop(context); // Cerrar el diálogo
      reseteaFormulario(); // Llamar al método de reseteo del formulario
    }
  }

   void _mdlinfoproyecto(String proyecto) async {
    Proyecto? proyecto_ = await _proyectosTabla.verProyecto(proyecto, widget.proId);

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
              key: _formularioProyectos,
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
                  Text('Id: ' + proyecto),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ListTile(
                    leading: Icon(Icons.lightbulb_circle, color: Colors.blue),
                    title: Text('Nombre del proyecto'),
                    subtitle: Text(
                      proyecto_?.nombre ?? 'Cargando...',
                    ),
                  ),
                 
                 
                  Divider(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ListTile(
                    leading: Icon(Icons.padding_sharp, color: Colors.blue),
                    title: Text('Descripción del proyecto'),
                    subtitle: Text(
                      proyecto_?.descripcion ?? 'Cargando...',
                    ),
                  ),
                   Divider(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ListTile(
                    leading: Icon(Icons.calendar_month, color: Colors.blue),
                    title: Text('Inicio del proyecto'),
                    subtitle: Text(
                     proyecto_?.fechaInicio?.toString() ?? 'Cargando...'

                    ),
                  ),
                  Divider(),
                   SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ListTile(
                    leading: Icon(Icons.calendar_month, color: Colors.blue),
                    title: Text('Fin del proyecto'),
                    subtitle: Text(
                      proyecto_?.fechaFinalizacion?.toString() ?? 'Cargando...',
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
  void _mdleliminarProyecto(String proyecto) {
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
              key: _formularioProyectos,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Ícono a la izquierda
                      SizedBox(width: 4), // Espacio entre el ícono y el texto
                      Text(
                        'Eliminar proyecto',
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
                  Text('Id: ' + proyecto),
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
              eliminarProyecto(proyecto);
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
  Future<void> eliminarProyecto(String equipo_) async {
    try {
      // Eliminar el usuario en Firestore
      await _proyectosTabla.eliminarProyecto(equipo_, widget.proId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Proyecto eliminado con éxito')),
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
    _fechaInicio.clear();
    _fechaFinalizacion.clear();
    _creacion.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Ejemplo de lista de proyectos

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Mis proyectos',
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
                _mdlagregarProyecto();
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
                StreamBuilder<List<Proyecto>>(
                  /*  future: listarproyectos(), */
                  stream: _proyectosTabla
                      .verProyectos_(widget.proId), // Escucha el stream
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No tienes proyectos.'));
                    } else {
                      var proyectosList = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap:
                            true, // Para evitar que ocupe todo el espacio
                        physics:
                            NeverScrollableScrollPhysics(), // Evita el desplazamiento dentro del ListView
                        itemCount: proyectosList.length,
                        itemBuilder: (context, index) {
                          var proyecto = proyectosList[index];
                          return InkWell(
                            onTap: () {
                              // Acción al hacer clic en la tarjeta
                              print('Tarjeta clickeada: ${proyecto.id}');
                              // Ejemplo: Navegar a otra página
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => DetalleproyectoPage(proyecto: proyecto)));
                              /*  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          proyectos(proId: proyecto.id!))); */
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
                                          proyecto.nombre,
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
                                                /*   proyecto.miembros!.length
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
                                            print('Información de proyecto');
                                            /*   _mdleliminarproyecto(proyecto.id!); */
                                            /*  _mdlinfoproyecto(proyecto.id!); */
                                            _mdlinfoproyecto(proyecto.id!);
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
                                            /*  _cargarDatosproyecto(proyecto.id!); */
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
                                            /*  _mdleliminarproyecto(proyecto.id!); */
                                            _mdleliminarProyecto(proyecto.id!);
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
