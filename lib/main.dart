import 'package:flutter/material.dart';
import 'package:proutvm/vistas/proyectos.dart';
import 'package:proutvm/vistas/equipos.dart';
import 'package:proutvm/vistas/perfil.dart';
import 'package:proutvm/vistas/acceso.dart'; // Asegúrate de importar la página de acceso
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'controladores/autenticacionCtrl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  int _selectedIndex = 0; 
  final _aut = autenticacionCtrl();
  String? _userId;
  bool _userLoaded = false;

  @override
  void initState() {
    super.initState();
    if (!_userLoaded) _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    final userId = await _aut.obtenerUsuario();
    setState(() {
      _userId = userId ?? null; 
      _userLoaded = true; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestor de Tareas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _userLoaded
          ? (_userId != null ? _buildUserHome() : accesoPagina()) // Redirect to access page if not authenticated
          : _buildLoadingScreen(), 
    );
  }

  Widget _buildUserHome() {
    final List<Widget> _screens = [
      equipos(userId: _userId!),
      perfil(userId: _userId!),
    ];

    return Scaffold(

      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(child: CircularProgressIndicator()); 
  }


  
}
