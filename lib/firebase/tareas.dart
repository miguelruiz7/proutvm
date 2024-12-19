import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proutvm/modelos/tarea.dart';

class tareasTabla {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener todas las tareas de un proyecto específico (usando uuidProyecto)
  Stream<List<Tarea>> verTareas(String uuidProyecto) {
    return _firestore
        .collection('tareas') // Colección principal de tareas
        .doc(uuidProyecto) // Proyecto específico (documento)
        .collection('tareas') // Subcolección de tareas
        .snapshots() // Obtener un stream de documentos
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        // Convertir los documentos en objetos Tarea
        var data = doc.data() as Map<String, dynamic>;
        return Tarea.fromFirestore(data, doc.id);
      }).toList();
    });
  }


  // Stream para tareas completadas
Stream<List<Tarea>> verTareasCompletadas(String uuidProyecto) {
  return _firestore
      .collection('tareas') // Colección principal de tareas
      .doc(uuidProyecto) // Proyecto específico (documento)
      .collection('tareas') // Subcolección de tareas
      .where('completado', isEqualTo: 1) // Filtrar por estado completada
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return Tarea.fromFirestore(data, doc.id);
    }).toList();
  });
}

// Stream para tareas en proceso
Stream<List<Tarea>> verTareasEnProceso(String uuidProyecto) {
  return _firestore
      .collection('tareas') // Colección principal de tareas
      .doc(uuidProyecto) // Proyecto específico (documento)
      .collection('tareas') // Subcolección de tareas
      .where('completado', isEqualTo: 0) // Filtrar por estado en proceso
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return Tarea.fromFirestore(data, doc.id);
    }).toList();
  });
}


  // Crear una nueva tarea en un proyecto específico
  Future<void> crearTarea(BuildContext context, Tarea tarea, String uuidProyecto) async {
    try {
      // Guardar la tarea en la subcolección 'tareas' dentro del proyecto especificado
      await _firestore
          .collection('tareas')
          .doc(uuidProyecto)
          .collection('tareas')
          .doc() // Crear un nuevo documento con ID generado automáticamente
          .set(tarea.toMap());

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Tarea creada correctamente!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      print('Tarea creada correctamente.');
    } catch (e) {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al crear la tarea: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      print('Error al crear la tarea: $e');
      throw Exception('No se pudo crear la tarea. Inténtalo de nuevo.');
    }
  }

  // Obtener una tarea específica dentro de un proyecto
  Future<Tarea?> verTarea(String uuidProyecto, String tareaId) async {
    try {
      final docSnapshot = await _firestore
          .collection('tareas')
          .doc(uuidProyecto)
          .collection('tareas')
          .doc(tareaId)
          .get();

      if (docSnapshot.exists) {
        return Tarea.fromMap(docSnapshot.data()!);
      } else {
        print('Tarea no encontrada');
        return null;
      }
    } catch (e) {
      print('Error al leer la tarea: $e');
      return null;
    }
  }

  // Eliminar una tarea dentro de un proyecto
  Future<void> eliminarTarea(String uuidProyecto, String tareaId) async {
    try {
      await _firestore
          .collection('tareas')
          .doc(uuidProyecto)
          .collection('tareas')
          .doc(tareaId)
          .delete();
      print('Tarea eliminada correctamente.');
    } catch (e) {
      print('Error al eliminar la tarea: $e');
    }
  }

  // Actualizar una tarea dentro de un proyecto
  Future<void> actualizarTarea(String uuidProyecto, Tarea tarea, identicadorTarea) async {
    try {
      await _firestore
          .collection('tareas')
          .doc(uuidProyecto)
          .collection('tareas')
          .doc(identicadorTarea) 
          .update(tarea.toMap());
      print('Tarea actualizada correctamente.');
    } catch (e) {
      print('Error al actualizar la tarea: $e');
    }
  }


    // Marcar tarea como completa
  Future<void> completarTarea(String uuidProyecto, String tareaId) async {
    try {
      await _firestore
          .collection('tareas')
          .doc(uuidProyecto)
          .collection('tareas')
          .doc(tareaId)
          .update({'completado': 1}); // Cambiar el estado a completado
      print('Tarea marcada como completa.');
    } catch (e) {
      print('Error al marcar la tarea como completa: $e');
      throw Exception('No se pudo marcar la tarea como completa. Inténtalo de nuevo.');
    }
  }

  // Revertir tarea completada
  Future<void> revertirTarea(String uuidProyecto, String tareaId) async {
    try {
      await _firestore
          .collection('tareas')
          .doc(uuidProyecto)
          .collection('tareas')
          .doc(tareaId)
          .update({'completado': 0}); // Cambiar el estado a no completado
      print('Estado de la tarea revertido a en proceso.');
    } catch (e) {
      print('Error al revertir la tarea: $e');
      throw Exception('No se pudo revertir la tarea. Inténtalo de nuevo.');
    }
  }

}
