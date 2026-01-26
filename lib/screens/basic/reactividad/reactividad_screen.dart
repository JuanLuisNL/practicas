import 'package:flutter/material.dart';

/// Ejercicio de reactividad con StatefulWidget
/// Demuestra cómo la UI se actualiza automáticamente cuando cambia el estado
class ReactividadScreen extends StatefulWidget {
  const ReactividadScreen({Key? key}) : super(key: key);

  @override
  State<ReactividadScreen> createState() => _ReactividadScreenState();
}

class _ReactividadScreenState extends State<ReactividadScreen> {
  // Estado
  int contador = 0;
  Color colorTitulo = Colors.indigo;
  Color colorLabel = Colors.white;
  Color colorFondo = Colors.indigo.shade900;
  double tamanoLabel = 48.0;
  double tamanoTitulo = 28.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reactividad - StatefulWidget'),
        backgroundColor: colorTitulo,
        elevation: 4,
      ),
      backgroundColor: colorFondo,
      body: Column(
        children: [
          // PARTE SUPERIOR: Título
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Mi Contador',
                  style: TextStyle(
                    fontSize: tamanoTitulo,
                    fontWeight: FontWeight.bold,
                    color: colorTitulo,
                    shadows: [
                      Shadow(
                        color: Colors.black.withAlpha((0.3 * 255).round()),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // CONTADOR CON BOTONES - Y +
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withAlpha((0.2 * 255).round()),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.2 * 255).round()),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botón MENOS
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            contador--;
                          });
                        },
                        icon: const Icon(Icons.remove, size: 24),
                        label: const Text(
                          'Menos',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          elevation: 6,
                        ),
                      ),
                      const SizedBox(width: 30),
                      // LABEL DEL CONTADOR
                      Text(
                        '$contador',
                        style: TextStyle(
                          fontSize: tamanoLabel,
                          fontWeight: FontWeight.w900,
                          color: colorLabel,
                          shadows: [
                            Shadow(
                              color: Colors.black.withAlpha((0.4 * 255).round()),
                              blurRadius: 6,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                      // Botón MÁS
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            contador++;
                          });
                        },
                        icon: const Icon(Icons.add, size: 24),
                        label: const Text(
                          'Más',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          elevation: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // PARTE INFERIOR: Botones para cambiar estilos
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Personaliza los estilos:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Fila 1: Colores del título
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildColorButton(Colors.indigo, 'Título Indigo', () {
                          setState(() => colorTitulo = Colors.indigo);
                        }),
                        _buildColorButton(Colors.purple, 'Título Purple', () {
                          setState(() => colorTitulo = Colors.purple);
                        }),
                        _buildColorButton(Colors.cyan, 'Título Cyan', () {
                          setState(() => colorTitulo = Colors.cyan);
                        }),
                        _buildColorButton(Colors.orange, 'Título Orange', () {
                          setState(() => colorTitulo = Colors.orange);
                        }),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Fila 2: Colores del label
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildColorButton(Colors.white, 'Label Blanco', () {
                          setState(() => colorLabel = Colors.white);
                        }),
                        _buildColorButton(Colors.yellow, 'Label Amarillo', () {
                          setState(() => colorLabel = Colors.yellow);
                        }),
                        _buildColorButton(Colors.lime, 'Label Lima', () {
                          setState(() => colorLabel = Colors.lime);
                        }),
                        _buildColorButton(Colors.pink, 'Label Rosa', () {
                          setState(() => colorLabel = Colors.pink);
                        }),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Fila 3: Colores del fondo
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildColorButton(Colors.indigo.shade900, 'Fondo Indigo', () {
                          setState(() => colorFondo = Colors.indigo.shade900);
                        }),
                        _buildColorButton(Colors.grey.shade900, 'Fondo Gris', () {
                          setState(() => colorFondo = Colors.grey.shade900);
                        }),
                        _buildColorButton(Colors.deepPurple.shade900, 'Fondo Purple', () {
                          setState(() => colorFondo = Colors.deepPurple.shade900);
                        }),
                        _buildColorButton(Colors.blue.shade900, 'Fondo Azul', () {
                          setState(() => colorFondo = Colors.blue.shade900);
                        }),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Fila 4: Tamaños
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildStyleButton('Label -', () {
                          setState(() {
                            if (tamanoLabel > 24) tamanoLabel -= 4;
                          });
                        }),
                        _buildStyleButton('Label +', () {
                          setState(() {
                            if (tamanoLabel < 72) tamanoLabel += 4;
                          });
                        }),
                        _buildStyleButton('Título -', () {
                          setState(() {
                            if (tamanoTitulo > 16) tamanoTitulo -= 2;
                          });
                        }),
                        _buildStyleButton('Título +', () {
                          setState(() {
                            if (tamanoTitulo < 40) tamanoTitulo += 2;
                          });
                        }),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Botón de reinicio
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          contador = 0;
                          colorTitulo = Colors.indigo;
                          colorLabel = Colors.white;
                          colorFondo = Colors.indigo.shade900;
                          tamanoLabel = 48.0;
                          tamanoTitulo = 28.0;
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reiniciar Todo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Método auxiliar para botones de color
  Widget _buildColorButton(Color color, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1),
        ),
      ),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withAlpha((0.15 * 255).round()),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 2,
      ),
    );
  }

  // Método auxiliar para botones de estilo
  Widget _buildStyleButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal.shade600,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
