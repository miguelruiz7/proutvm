class Validadorsvc {
   
   
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

}