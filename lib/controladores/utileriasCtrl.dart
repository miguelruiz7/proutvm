import 'dart:math';


class Utileriasctrl {
  String generarCodigoAleatorio() {
  const caracteres = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return List.generate(6, (index) => caracteres[random.nextInt(caracteres.length)]).join();
}


}