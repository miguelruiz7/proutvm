import 'package:proutvm/firebase/equipos.dart';


class Validadorsvc {

    final equiposTabla _equiposTabla = equiposTabla();
   

   // Perfil
   
    // Validar nombre 
  String? validarNombre(String? value) {
    // Verifica si es nulo
    if (value == null || value.isEmpty) {
      return 'El nombre es obligatorio';
    }
    // Que tenga más de cuatro caracteres
    if (value.length < 4) {
      return 'Debe tener 4 caracteres mínimo';
    }
   
    //Que tenga como minimo 2 palabras
    if (value.split(' ').length < 2) {
      return 'Debe tener apellidos';
    }
    return null;
  }


    // Validación del campo de correo
  String? validarCorreo(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo es obligatorio';
    }
    final RegExp correoRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!correoRegex.hasMatch(value)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  // Validación del campo de contraseña
  String? validarContrasena(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    } else if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

    // Validación de la confirmación de la contraseña
  String? validarConfirmarContrasena(String? value, String? value2) {
    if (value == null || value.isEmpty) {
      return 'La confirmación de contraseña es obligatoria';
    }
    if (value != value2) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

 // Equipo

     // Validar nombre 
  String? validarNombreEquipo(String? value) {
    // Verifica si es nulo
    if (value == null || value.isEmpty) {
      return 'El nombre es obligatorio';
    }
    // Que tenga más de cuatro caracteres
    if (value.length < 4) {
      return 'Debe tener 4 caracteres mínimo';
    }
   
    return null;
  }


String? validarComboParrafo(String? value, int? max) {
  // Verifica si el valor es nulo o está vacío
  if (value == null || value.isEmpty) {
    return 'El campo es obligatorio';
  }

  // Verifica si el valor tiene menos caracteres que el máximo permitido
  if (max != null && value.length < max) {
    return 'Debe tener al menos $max caracteres';
  }
  
  return null; // Retorna null si no hay errores
}

// Validar si el código de equipo es válido
String? validarCodigoEquipo(String? value)  {
  if (value == null || value.isEmpty) {
    return 'El código de equipo es obligatorio';
  }
  if (value.length != 6) {
    return 'El código de equipo debe tener 6 caracteres';
  }
  
 /*  // Verificar la existencia en Firebase
  final existeEnFirebase = await _equiposTabla.verificarExistenciaEquipo(value);
  if (!existeEnFirebase) {
    return 'El código de equipo no existe en el sistema';
  } */
  
  return null; 
}

// Validar si el código de equipo es válido
Future<bool> validarCodigoEquipoAs(String? codigo) async {
  if (codigo == null) {
    // Manejar el caso en el que el código es nulo
    return false;
  }

  final existeEnFirebase = await _equiposTabla.verificarExistenciaEquipo(codigo);
  return existeEnFirebase;
}




}