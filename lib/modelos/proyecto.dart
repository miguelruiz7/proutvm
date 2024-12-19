import 'package:cloud_firestore/cloud_firestore.dart';

class Proyecto {
  final String? id;
  final String nombre;
  final String descripcion;
  final DateTime fechaInicio;
  final DateTime fechaFinalizacion;
  final DateTime creacion;

  Proyecto({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.creacion,
    required this.fechaInicio,
    required this.fechaFinalizacion,
  });

factory Proyecto.fromFirestore(Map<String, dynamic> data, String id) {
  return Proyecto(
    id: id,
    nombre: data['nombre'] ?? '',
    descripcion: data['descripcion'] ?? '',
    creacion: data['creacion'] != null ? (data['creacion'] as Timestamp).toDate() : DateTime.now(), // Default to current date if null
    fechaInicio: data['fechaInicio'] != null ? (data['fechaInicio'] as Timestamp).toDate() : DateTime.now(), // Default to current date if null
    fechaFinalizacion: data['fechaFinalizacion'] != null ? (data['fechaFinalizacion'] as Timestamp).toDate() : DateTime.now(), // Default to current date if null
  );
}


 factory Proyecto.fromMap(Map<String, dynamic> data) {
    return Proyecto(
      id: data['id'],
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      creacion: data['creacion'] != null
          ? (data['creacion'] as Timestamp).toDate()
          : DateTime.now(),
      fechaInicio: data['fechaInicio'] != null
          ? (data['fechaInicio'] as Timestamp).toDate()
          : DateTime.now(),
      fechaFinalizacion: data['fechaFinalizacion'] != null
          ? (data['fechaFinalizacion'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'creacion': Timestamp.fromDate(creacion),
      'fechaInicio': Timestamp.fromDate(fechaInicio),
      'fechaFinalizacion': Timestamp.fromDate(fechaFinalizacion),
    };
  }

 
}
