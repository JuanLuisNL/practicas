import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuCardItem {
  final String label;
  final IconData icon;
  MenuCardItem({required this.label, required this.icon});
}

class ColumnasController extends GetxController {
  // seleccionado (-1 = ninguno)
  final selected = (-1).obs;
  RxInt oColsGrid = 3.obs;

  // 12 elementos (4 filas x 3 columnas) - cambiado de 18 a 12
  final items = <MenuCardItem>[
    for (var i = 1; i <= 12; i++)
      MenuCardItem(label: 'Elemento $i', icon: _iconFor(i)),
  ];

  void select(int index) {
    if (selected.value == index) {
      selected.value = -1;
    } else {
      selected.value = index;
    }
  }

  static IconData _iconFor(int i) {
    // Cicla entre varios iconos para que la demo se vea variada
    const icons = [
      Icons.home,
      Icons.camera_alt,
      Icons.book,
      Icons.map,
      Icons.alarm,
      Icons.chat,
      Icons.cake,
      Icons.code,
      Icons.photo,
      Icons.play_arrow,
      Icons.pie_chart,
      Icons.lock,
      Icons.flight,
      Icons.music_note,
      Icons.phone,
      Icons.settings,
      Icons.star,
      Icons.work,
    ];
    return icons[(i - 1) % icons.length];
  }

  Color colorForRow(int row) {
    // Para que se aprecie la diferencia: las dos primeras filas (0 y 1 => items 1-6)
    // serán tonos naranja; las dos siguientes tonos verde. Devolvemos colores
    // sólidos (sin alpha) y el widget `ModernCardWidget` aplicará la transparencia
    // para el efecto cristal.
    if (row < 6) {
      // Naranja (ligeramente cálido para contrastar con el fondo azul)
      return Colors.orange;
    }
    // Verde para filas 2 y 3
    return Colors.green.shade400;
  }

  void setNCols(int i) {
    oColsGrid.value = i;
  }
}
