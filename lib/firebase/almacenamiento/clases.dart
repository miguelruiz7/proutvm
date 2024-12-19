import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class clasesAlmacenamiento {
  final FirebaseStorage _storage = FirebaseStorage.instance;



  Future<String> subirFotoPerfil(String userId, File? file) async {
  if (file == null || !file.existsSync()) {
    print('File does not exist: ${file?.path}');
    return "";
  }

  if (userId.isEmpty) {
    print('Invalid userId: $userId');
    return "";
  }

  try {
    print('Starting upload for userId: $userId, file: ${file.path}');
    final reference = _storage.ref().child('perfil/$userId.jpg');
    final task = reference.putFile(file);

    // Monitor upload progress
    task.snapshotEvents.listen((TaskSnapshot snapshot) {
      print('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
    });

    final snapshot = await task.whenComplete(() => null);
    final url = await snapshot.ref.getDownloadURL();
    print('Upload successful. File URL: $url');
    return url;
  } catch (e) {
    print('Upload failed: ${e.toString()}');
    return "";
  }
}



/* Future<String> subirFotoPerfil(String userId, File file) async {
  Reference reference = FirebaseStorage.instance.ref('imagenes/' + userId + '.jpg');
  final TaskSnapshot snapshot = await reference.putFile(file);
  final downloadUrl = await snapshot.ref.getDownloadURL();
  return downloadUrl;
} */








}

