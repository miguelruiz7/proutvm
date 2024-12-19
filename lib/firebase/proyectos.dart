import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proutvm/modelos/proyecto.dart';
import 'package:flutter/material.dart';


class proyectosTabla {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Stream<List<Proyecto>> verProyectos_(String equipo) {
  return _firestore.collection('equipos')
        .doc(equipo)
        .collection('proyectos') 
    .snapshots() // Obtener un stream de documentos de Firestore
    .map((snapshot) {
      return snapshot.docs.map((doc) {
        // Obtener los datos del documento usando .data() y hacer el cast correcto
        var data = doc.data() as Map<String, dynamic>; // Usar .data() para obtener los datos
        return Proyecto.fromFirestore(data, doc.id); // Convertir el documento a un objeto Equipo
      }).toList();
    });
}

Future<void> crearProyecto(BuildContext context, Proyecto proyecto, String equipo) async {
  try {
    print("Proyecto" +equipo);
    // Guardar el equipo en Firestore
    await _firestore.collection('equipos').doc(equipo).collection('proyectos').doc().set(proyecto.toMap());

    // Mostrar un mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Equipo creado correctamente!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    print('Equipo creado correctamente con ID: $equipo.');
  } catch (e) {
    // Mostrar un mensaje de error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error al crear el equipo: $e'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
    print('Error al crear el equipo: $e');
    throw Exception('No se pudo crear el equipo. Inténtalo de nuevo.');
  }
}


// Leer un equipo en especifico
  Future<Proyecto?> verProyecto(String identificadorProyecto, String equipo) async {
    try {
      final docSnapshot = await _firestore.collection('equipos').doc(equipo).collection('proyectos').doc(identificadorProyecto).get();
      if (docSnapshot.exists) {
        // Si el documento existe, convierte los datos en un objeto Equipo
        return Proyecto.fromMap(docSnapshot.data()!);
      } else {
        print('Proyecto no encontrado');
        return null;
      }
    } catch (e) {
      print('Error al leer el equipo: $e');
      return null;
    }
  }


// Eliminar un equipo
  Future<void> eliminarProyecto(String identificadorProyecto, equipo ) async {
    await _firestore
       .collection('equipos').doc(equipo).collection('proyectos')
       .doc(identificadorProyecto)
       .delete();
  }


// Actualizar un proyecto
Future<void> actualizarProyecto(Proyecto proyecto, String identificadorEquipo, String identificadorProyecto) async {
  try {
    // Acceder al documento específico y actualizar sus datos
    await _firestore
        .collection('equipos')
        .doc(identificadorEquipo)
        .collection('proyectos')
        .doc(identificadorProyecto)
        .update(proyecto.toMap()); // Convierte el objeto Proyecto a un mapa
    print('Proyecto actualizado correctamente.');
  } catch (e) {
    print('Error al actualizar el proyecto: $e');
    throw Exception('No se pudo actualizar el proyecto. Inténtalo de nuevo.');
  }
}



}