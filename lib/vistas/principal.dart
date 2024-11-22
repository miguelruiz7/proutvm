import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proutvm/vistas/equipos.dart';
import 'acceso.dart'; // Asegúrate de tener la vista de login importada
import 'package:proutvm/vistas/perfil.dart';

class principalPag extends StatefulWidget {
  const principalPag({super.key});

  @override
  State<principalPag> createState() => _principalPagState();
}

class _principalPagState extends State<principalPag> {
  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.selected;
  bool showLeading = false;
  bool showTrailing = false;
  double groupAlignment = -1.0;

  @override
  void initState() {
    super.initState();
    _checkAuthentication(); // Verificar la autenticación al iniciar el widget
  }

  // Método para verificar si el usuario está autenticado
  void _checkAuthentication() {
    User? user = FirebaseAuth.instance.currentUser;

    // Si el usuario no está autenticado, redirige al login
    if (user == null) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => accesoPagina()), // Redirige al login
        );
      });
    }
  }

  // Método para cerrar sesión
  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              accesoPagina()), // Redirige al login después de cerrar sesión
    );
  }

  // Aquí decides qué widget mostrar en función del índice seleccionado
  Widget _getSelectedPage(int index) {
    User? user = FirebaseAuth.instance.currentUser;

    switch (index) {
      case 0:
        return Center(child: Text('Página de Inicio'));
      case 1:
        return user != null
            ? perfilUsuario(userId: user.uid)
            : Center(child: Text('Usuario no autenticado'));
      case 2:
          return user != null
            ? equipos(userId: user.uid)
            : Center(child: Text('Usuario no autenticado'));
      case 3:
        _signOut();
        return Container(); // Devuelve un contenedor vacío mientras se cierra la sesión
      default:
        return Center(child: Text('Página no encontrada'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: <Widget>[
            NavigationRail(
              selectedIndex: _selectedIndex,
              groupAlignment: groupAlignment,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: labelType,
              leading: showLeading
                  ? FloatingActionButton(
                      elevation: 0,
                      onPressed: () {
                        // Agrega la lógica que desees aquí
                      },
                      child: const Icon(Icons.add),
                    )
                  : const SizedBox(),
              trailing: showTrailing
                  ? IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_horiz_rounded),
                    )
                  : const SizedBox(),
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
            const VerticalDivider(thickness: 1, width: 1),
            // El contenido principal cambia según el índice seleccionado
            Expanded(
              child: _getSelectedPage(_selectedIndex),
            ),
          ],
        ),
      ),
    );
  }
}

/* // Página de Perfil
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Perfil de Usuario',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text('Nombre: John Doe'), // Puedes cambiar esto por campos reales
          Text('Correo: john.doe@gmail.com'), // Y agregar edición como vimos antes
        ],
      ),
    );
  }
}
 */