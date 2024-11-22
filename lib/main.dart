import 'package:flutter/material.dart';
import 'package:proutvm/vistas/principal.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase/firebase_options.dart'; 


void main() async { 
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( 
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestor de Tareas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      
      ),
      home: principalPag(),
    );
  }
}






