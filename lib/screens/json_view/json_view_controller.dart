import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// función que se ejecuta en isolate para parsear JSON
dynamic parseJsonIsolate(String raw) {
  return json.decode(raw);
}

class JsonViewController extends GetxController {
  final isLoading = false.obs;
  final error = RxnString();
  final data = Rxn<dynamic>();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    if (isLoading.value) return;
    isLoading.value = true;
    error.value = null;
    data.value = null;
    try {
      final raw = await rootBundle.loadString('assets/datos.json');
      if (raw.trim().isEmpty) {
        data.value = null;
        error.value = 'Archivo vacío';
      } else {
        // parsear en isolate para evitar bloquear UI con JSON grande
        final parsed = await compute(parseJsonIsolate, raw);
        data.value = parsed;
      }
    } on FormatException catch (e) {
      error.value = 'Error parseando JSON: ${e.message}';
    } catch (e) {
      // cubrir errores de acceso a asset u otros
      error.value = 'Error inesperado: $e';
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
