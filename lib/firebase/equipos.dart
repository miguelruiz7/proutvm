import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:proutvm/modelos/equipo.dart';
import 'package:flutter/material.dart';

class equiposTabla {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



Future<void> crearEquipo(BuildContext context, Equipo equipo) async {
  try {
    // Aquí podrías agregar tu código de Firestore para agregar el equipo
    await _firestore
        .collection('equipos')
        .add(equipo.toMap()); // Genera automáticamente un ID único

    // Mostrar un mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Equipo creado correctamente!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    print('Equipo creado correctamente con un ID aleatorio.');
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

Future<List<Equipo>> verEquipos(String identificadorUsuario) async {
  try {
    final querySnapshot = await _firestore
        .collection('equipos')
        .where('miembros', arrayContains: identificadorUsuario)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Equipo.fromFirestore(data, doc.id);
    }).toList();
  } catch (e) {
    print('Error al leer los equipos: $e');
    return [];
  }
}

Stream<List<Equipo>> verEquipos_(String userId) {
  return _firestore.collection('equipos') // Colección de equipos en Firestore
    .where('miembros', arrayContains: userId) // Filtra por miembro
    .snapshots() // Obtener un stream de documentos de Firestore
    .map((snapshot) {
      return snapshot.docs.map((doc) {
        // Obtener los datos del documento usando .data() y hacer el cast correcto
        var data = doc.data() as Map<String, dynamic>; // Usar .data() para obtener los datos
        return Equipo.fromFirestore(data, doc.id); // Convertir el documento a un objeto Equipo
      }).toList();
    });
}


// Leer un equipo en especifico
  Future<Equipo?> verEquipo(String identificadorEquipo) async {
    try {
      final docSnapshot = await _firestore.collection('equipos').doc(identificadorEquipo).get();
      if (docSnapshot.exists) {
        // Si el documento existe, convierte los datos en un objeto Equipo
        return Equipo.fromMap(docSnapshot.data()!);
      } else {
        print('Equipo no encontrado');
        return null;
      }
    } catch (e) {
      print('Error al leer el equipo: $e');
      return null;
    }
  }


   // Actualizar un usuario
  Future<void> actualizarEquipo(Equipo equipo, String identificadorEquipo) async {
    await _firestore
       .collection('equipos')
       .doc(identificadorEquipo)
       .update(equipo.toMap()); // Convierte el objeto Usuario a un mapa de datos
  }

  // Eliminar un equipo
  Future<void> eliminarEquipo(String identificadorEquipo) async {
    await _firestore
       .collection('equipos')
       .doc(identificadorEquipo)
       .delete();
  }



Future<bool> verificarExistenciaEquipo(String codigoEquipo) async {
  try {
    final querySnapshot = await _firestore
        .collection('equipos')
        .where('codigo', whereIn: [codigoEquipo] )
        .get();

    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    print('Error al verificar el código de equipo: $e');
    // Mostrar un mensaje de error más específico al usuario
    return false;
  }
}

}