import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller para gestionar la reactividad con GetX
/// Demuestra el uso de variables reactivas (.obs) y update()
class ReactividadGetxController extends GetxController {
  // Variables reactivas
  final RxInt contador = 0.obs;
  final Rx<Color> colorTitulo = Colors.indigo.obs;
  final Rx<Color> colorLabel = Colors.white.obs;
  final Rx<Color> colorFondo = Colors.indigo.shade900.obs;
  final RxDouble tamanoLabel = 48.0.obs;
  final RxDouble tamanoTitulo = 28.0.obs;

  // Métodos para cambiar el contador
  void incrementar() {
    contador.value++;
  }

  void decrementar() {
    contador.value--;
  }

  // Métodos para cambiar colores
  void setColorTitulo(Color color) {
    colorTitulo.value = color;
  }

  void setColorLabel(Color color) {
    colorLabel.value = color;
  }

  void setColorFondo(Color color) {
    colorFondo.value = color;
  }

  // Métodos para cambiar tamaños
  void aumentarTamanoLabel() {
    if (tamanoLabel.value < 72) {
      tamanoLabel.value += 4;
    }
  }

  void disminuirTamanoLabel() {
    if (tamanoLabel.value > 24) {
      tamanoLabel.value -= 4;
    }
  }

  void aumentarTamanoTitulo() {
    if (tamanoTitulo.value < 40) {
      tamanoTitulo.value += 2;
    }
  }

  void disminuirTamanoTitulo() {
    if (tamanoTitulo.value > 16) {
      tamanoTitulo.value -= 2;
    }
  }

  // Método para reiniciar todo
  void reiniciar() {
    contador.value = 0;
    colorTitulo.value = Colors.indigo;
    colorLabel.value = Colors.white;
    colorFondo.value = Colors.indigo.shade900;
    tamanoLabel.value = 48.0;
    tamanoTitulo.value = 28.0;
  }
}
