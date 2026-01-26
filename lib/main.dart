import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practicas/screens/menu/menu_page.dart';
import 'package:practicas/features/chutes_chat/pages/chat_page.dart';
import 'package:practicas/features/chutes_chat/bindings/chat_binding.dart';
import 'package:practicas/screens/course/course_page.dart';
import 'package:practicas/screens/images/images_page.dart';
import 'package:practicas/screens/checkbox_widget/checkbox_example_page.dart';
import 'package:practicas/screens/basic/columnas/columnas_page.dart';
import 'package:practicas/screens/basic/sqlite/sqlite_page.dart';
import 'package:window_manager/window_manager.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'global/global.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  if (GBL.isDesktop) {
    // Inicializar sqflite_ffi para desktop
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(600, 900),
      minimumSize: Size(600, 900),
      maximumSize: Size(5000, 8000),
      center: true,
      backgroundColor: Colors.transparent,
      titleBarStyle: TitleBarStyle.normal,

    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const PracticasApp());
}

class PracticasApp extends StatelessWidget {
  const PracticasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // Registrar rutas GetX (la página de menú se deja como home)
      getPages: [
        GetPage(name: '/', page: () => const MenuPage()),
        GetPage(name: '/chat', page: () => const ChatPage(), binding: ChatBinding()),
        GetPage(name: '/course', page: () => const CoursePage()),
        GetPage(name: '/images', page: () => const ImagesPage()),
        GetPage(name: '/checkbox', page: () => const CheckboxExamplePage()),
        GetPage(name: '/columnas', page: () => const ColumnasFilasPage()),
        GetPage(name: '/sqlite', page: () => const SqlitePage()),
      ],
      home: const MenuPage(),
    );
  }
}
