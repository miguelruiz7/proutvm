import 'package:flutter/material.dart';
import 'package:proutvm/vistas/tareas_proceso.dart';
import 'package:proutvm/vistas/tareas_completadas.dart';

class tareas extends StatefulWidget {
  final String proId;

  const tareas({Key? key, required this.proId}) : super(key: key);

  @override
  _tareasState createState() => _tareasState();
}

class _tareasState extends State<tareas> {
  int _selectedIndex = 0;
   
 @override

 Widget build(BuildContext context) {
    return Scaffold(      
       body: _tareasPantallas(),
    );
  }

 Widget _tareasPantallas() {
    final List<Widget> _screens = [
        tareasProceso(proId: widget.proId),
         tareasCompletadas(proId: widget.proId)
    ];

    return Scaffold(


      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.timelapse_sharp),
            label: 'En proceso',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'Concluido',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }



}

