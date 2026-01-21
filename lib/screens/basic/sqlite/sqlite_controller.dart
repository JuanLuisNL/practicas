import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:path_provider/path_provider.dart';

class SqliteController extends GetxController {
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final columns = <TrinaColumn>[].obs;
  final rows = <TrinaRow>[].obs;

  Database? _database;

  @override
  void onInit() {
    super.onInit();
    _initDatabase();
  }

  @override
  void onClose() {
    _database?.close();
    super.onClose();
  }

  Future<void> _initDatabase() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final dbPath = await _copyDatabaseFromAssets();

      if (!await File(dbPath).exists()) {
        throw Exception('El archivo de base de datos no existe en: $dbPath');
      }

      _database = await openDatabase(
        dbPath,
        readOnly: true,
        singleInstance: false,
      );

      await _loadTableData();

      isLoading.value = false;
    } catch (e) {
      errorMessage.value = 'Error al cargar la base de datos: $e';
      isLoading.value = false;
    }
  }

  Future<String> _copyDatabaseFromAssets() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final dbDir = join(documentsDirectory.path, 'databases');

    await Directory(dbDir).create(recursive: true);

    final dbPath = join(dbDir, 'datos.db');

    final ByteData data = await rootBundle.load('assets/datos.db');
    final List<int> bytes = data.buffer.asUint8List();
    await File(dbPath).writeAsBytes(bytes);

    return dbPath;
  }

  Future<void> _loadTableData() async {
    if (_database == null) return;

    final tables = await _database!.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
    );

    if (tables.isEmpty) {
      errorMessage.value = 'No se encontraron tablas en la base de datos';
      return;
    }

    final tableName = tables.first['name'] as String;
    final tableInfo = await _database!.rawQuery('PRAGMA table_info($tableName)');

    final trinaColumns = <TrinaColumn>[];
    for (var colInfo in tableInfo) {
      final columnName = colInfo['name'] as String;
      trinaColumns.add(
        TrinaColumn(
          title: columnName,
          field: columnName,
          type: TrinaColumnType.text(),
          width: 150,
        ),
      );
    }
    columns.value = trinaColumns;

    final data = await _database!.query(tableName);

    final trinaRows = <TrinaRow>[];
    for (var i = 0; i < data.length; i++) {
      final row = data[i];
      final cells = <String, TrinaCell>{};

      for (var colInfo in tableInfo) {
        final columnName = colInfo['name'] as String;
        cells[columnName] = TrinaCell(value: row[columnName]?.toString() ?? '');
      }

      trinaRows.add(
        TrinaRow(cells: cells),
      );
    }
    rows.value = trinaRows;
  }

  @override
  Future<void> refresh() async {
    await _initDatabase();
  }
}
