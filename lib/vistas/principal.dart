/* import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proutvm/vistas/equipos.dart';
import 'acceso.dart'; 
import 'package:proutvm/vistas/perfil.dart';

class principalPag extends StatefulWidget {
  const principalPag({super.key});

  @override
  State<principalPag> createState() => _principalPagState();
}

class _principalPagState extends State<principalPag> {
  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.selected;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  void _checkAuthentication() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Redirect to login with a smoother transition
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => accesoPagina(),
        ),
      );
    }
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => accesoPagina(),
      ),
    );
  }

  Widget _getSelectedPage(int index) {
    User? user = FirebaseAuth.instance.currentUser;

    switch (index) {
      case 0:
        return Center(child: Text('Página de Inicio'));
      case 1:
        return user != null
            ? perfilUsuario(userId: user.uid) // Replace with actual profile view
            : Center(child: Text('Usuario no autenticado'));
      case 2:
        return user != null
            ? equipos(userId: user.uid)
            : Center(child: Text('Usuario no autenticado'));
      case 3:
        _signOut();
        return Container(); // Empty container while signing out
      default:
        return Center(child: Text('Página no encontrada'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // NavigationRail with bottom positioning
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: labelType,
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Inicio'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person),
                  selectedIcon: Icon(Icons.person),
                  label: Text('Config.'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.group),
                  selectedIcon: Icon(Icons.group),
                  label: Text('Equipos'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.exit_to_app),
                  selectedIcon: Icon(Icons.exit_to_app),
                  label: Text('Cerrar Sesión'),
                ),
              ],
            ),
            // Vertical divider for visual separation
            const VerticalDivider(thickness: 1),
            // Expanded content area
            Expanded(
              child: _getSelectedPage(_selectedIndex),
            ),
          ],
        ),
      ),
    );
  }
} */