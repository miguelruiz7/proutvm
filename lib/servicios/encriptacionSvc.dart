import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/asymmetric/api.dart';

class EncriptacionSvc {
  RSAPublicKey? _rsaPublicKey;
  RSAPrivateKey? _rsaPrivateKey;

  Future<void> _cargarClaves() async {
    // Cargar y analizar las claves solo una vez
    if (_rsaPublicKey == null || _rsaPrivateKey == null) {
      final publicKey = await rootBundle.loadString('assets/keys/proutvm_pub.pem');
      final privateKey = await rootBundle.loadString('assets/keys/proutvm_priv.pem');
      
      final parser = RSAKeyParser();
      _rsaPublicKey = parser.parse(publicKey) as RSAPublicKey;
      _rsaPrivateKey = parser.parse(privateKey) as RSAPrivateKey;
    }
  }

  Future<String> encriptar(String cadena) async {
    await _cargarClaves();  // Asegura que las claves están cargadas
    
    final encrypter = Encrypter(RSA(publicKey: _rsaPublicKey!, privateKey: _rsaPrivateKey));
    return encrypter.encrypt(cadena).base64;
  }

  Future<String> desencriptar(String cadenaEncriptada) async {
    await _cargarClaves();  // Asegura que las claves están cargadas
    
    final decrypter = Encrypter(RSA(privateKey: _rsaPrivateKey!));
    return decrypter.decrypt64(cadenaEncriptada);
  }
}

