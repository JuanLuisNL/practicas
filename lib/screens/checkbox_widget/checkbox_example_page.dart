import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_checkbox.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CheckboxExamplePage extends StatefulWidget {
  const CheckboxExamplePage({super.key});

  @override
  State<CheckboxExamplePage> createState() => _CheckboxExamplePageState();
}

class _CheckboxExamplePageState extends State<CheckboxExamplePage> {
  late final ValueNotifier<String> _labelNotifier;
  late final ValueNotifier<int> _counter;
  bool? _initialChecked;

  @override
  void initState() {
    super.initState();
    _labelNotifier = ValueNotifier<String>('Marcar como completado');
    _counter = ValueNotifier<int>(0);
    _loadPersisted();
  }

  Future<void> _loadPersisted() async {
    final prefs = await SharedPreferences.getInstance();
    final label = prefs.getString('checkbox_label') ?? 'Marcar como completado';
    final counter = prefs.getInt('checkbox_counter') ?? 0;
    final checked = prefs.getBool('checkbox_checked') ?? false;

    _labelNotifier.value = label;
    _counter.value = counter;
    // El CustomCheckbox mantiene su propio estado interno; para inicializarlo,
    // pasaremos initialValue desde aquí usando un Keyed approach: recrear el widget con la bandera.
    setState(() {
      _initialChecked = checked;
    });
  }

  @override
  void dispose() {
    _labelNotifier.dispose();
    _counter.dispose();
    super.dispose();
  }

  void _changeLabel() {
    final c = _counter.value + 1;
    _counter.value = c;
    _labelNotifier.value = 'Marcar como completado ($c)';
    _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('checkbox_label', _labelNotifier.value);
    await prefs.setInt('checkbox_counter', _counter.value);
    await prefs.setBool('checkbox_checked', _initialChecked ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ejemplo Checkbox')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomCheckbox(
              key: ValueKey('custom_checkbox_1'),
              labelNotifier: _labelNotifier,
              initialValue: _initialChecked ?? false,
              onChanged: (v) {
                // guardar el estado
                _initialChecked = v;
                _persist();
                Get.snackbar('Estado', 'Checked: $v');
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _changeLabel, child: const Text('Cambiar label')),
            const SizedBox(height: 8),
            TextButton(onPressed: () {
              _labelNotifier.value = 'Etiqueta fija';
              _persist();
            }, child: const Text('Fijar etiqueta'))
          ],
        ),
      ),
    );
  }
}
