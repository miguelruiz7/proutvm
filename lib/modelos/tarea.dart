import 'package:cloud_firestore/cloud_firestore.dart';

class Tarea {
  final String? id;
  final String nombre;
  final String descripcion;
  final DateTime fechaInicio;
  final DateTime fechaFinalizacion;
  final List<dynamic>? miembros;
  final int completado;
  final String? evidencia; // Campo opcional para evidencia

  Tarea({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.fechaInicio,
    required this.fechaFinalizacion,
    this.miembros,
    this.completado = 0,
    this.evidencia, // Añadido el parámetro de evidencia
  });

  factory Tarea.fromFirestore(Map<String, dynamic> data, String id) {
    return Tarea(
      id: id,
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      fechaInicio: data['fechaInicio'] != null
          ? (data['fechaInicio'] as Timestamp).toDate()
          : DateTime.now(),
      fechaFinalizacion: data['fechaFinalizacion'] != null
          ? (data['fechaFinalizacion'] as Timestamp).toDate()
          : DateTime.now(),
      miembros: data['miembros'] as List<dynamic>?,
      completado: data['completado'] ?? 0,
      evidencia: data['evidencia'], // Extraemos la evidencia si existe
    );
  }

  factory Tarea.fromMap(Map<String, dynamic> data) {
    return Tarea(
      id: data['id'],
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      fechaInicio: data['fechaInicio'] != null
          ? (data['fechaInicio'] as Timestamp).toDate()
          : DateTime.now(),
      fechaFinalizacion: data['fechaFinalizacion'] != null
          ? (data['fechaFinalizacion'] as Timestamp).toDate()
          : DateTime.now(),
      miembros: data['miembros'] as List<dynamic>?,
      completado: data['completado'] ?? 0,
      evidencia: data['evidencia'], // Extraemos la evidencia si existe
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'fechaInicio': Timestamp.fromDate(fechaInicio),
      'fechaFinalizacion': Timestamp.fromDate(fechaFinalizacion),
      if (miembros != null) 'miembros': miembros,
      'completado': completado,
      if (evidencia != null) 'evidencia': evidencia, // Agregamos evidencia solo si no es null
    };
  }
}
