import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'lesson_page.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  static final List<Map<String, dynamic>> _modules = [
    {
      'title': 'Módulo 1 — Introducción & arquitectura',
      'lessons': [
        {
          'title': 'Arquitectura de la app',
          'content': 'Revisión de carpetas, feature-first y patrones de separación.'
        },
        {
          'title': 'GetX overview',
          'content': 'Breve introducción a GetX: Controllers, Bindings y rutas.'
        }
      ]
    },
    {
      'title': 'Módulo 2 — Cámara y permisos',
      'lessons': [
        {'title': 'Permisos', 'content': 'Uso de permission_handler y control de estados.'},
        {'title': 'Captura de imagen', 'content': 'Usar plugin camera para tomar y guardar fotos.'}
      ]
    },
    {
      'title': 'Módulo 3 — JSON dinámico y UI',
      'lessons': [
        {'title': 'Parseo JSON', 'content': 'Cargar assets/datos.json y mapear a modelos.'},
        {'title': 'UI dinámica', 'content': 'Renderizar lecciones desde JSON.'}
      ]
    },
    {
      'title': 'Módulo 4 — Integración con LLM (Chutes)',
      'lessons': [
        {'title': 'Servicios HTTP', 'content': 'Implementar ChutesApiService e inyectarlo.'},
        {'title': 'Chat UI', 'content': 'Flow del chat y manejo de estados.'}
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estructura del curso')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _modules.length,
        itemBuilder: (context, i) {
          final module = _modules[i];
          final lessons = module['lessons'] as List<dynamic>;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ExpansionTile(
              title: Text(module['title'] as String),
              children: lessons.map<Widget>((l) {
                return ListTile(
                  title: Text(l['title'] as String),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.to(() => LessonPage(
                          title: l['title'] as String,
                          content: l['content'] as String,
                        ));
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
