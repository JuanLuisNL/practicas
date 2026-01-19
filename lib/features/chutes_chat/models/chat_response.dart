import 'dart:convert';

class ChatChoice {
  final String role;
  final String content;

  ChatChoice({required this.role, required this.content});

  /// Extrae texto y role de la estructura variada que puede devolver la API
  factory ChatChoice.fromMap(Map<String, dynamic> map) {
    String role = 'assistant';
    String content = '';

    // role heuristics
    if (map['role'] is String) {
      role = map['role'] as String;
    } else if (map['message'] is Map) {
      final m = map['message'] as Map<dynamic, dynamic>;
      if (m.containsKey('role') && m['role'] is String) role = m['role'] as String;
    }

    // content heuristics: try several common shapes
    dynamic tryGetContent(Map<String, dynamic> m) {
      if (m.containsKey('content')) return m['content'];
      if (m.containsKey('message')) return m['message'];
      if (m.containsKey('delta')) return m['delta'];
      if (m.containsKey('text')) return m['text'];
      if (m.containsKey('output')) return m['output'];
      return null;
    }

    dynamic candidate = tryGetContent(map);
    if (candidate == null) {
      // scan nested maps for first textual field
      for (var v in map.values) {
        if (v is String && v.trim().isNotEmpty) {
          candidate = v;
          break;
        }
        if (v is Map && v.containsKey('content')) {
          candidate = v['content'];
          break;
        }
      }
    }

    String extractFrom(dynamic c) {
      if (c == null) return '';
      if (c is String) return c;
      if (c is Map) {
        // if content is string inside map
        final vContent = c['content'];
        if (vContent is String) return vContent;
        // if content is list of parts
        if (vContent is List) {
          final parts = vContent
              .map((e) => e is Map && e['text'] is String ? e['text'] as String : (e is String ? e : ''))
              .where((s) => s.isNotEmpty)
              .cast<String>()
              .toList();
          return parts.join('');
        }

        // message.content could be a list or string
        final vMessage = c['message'];
        if (vMessage is Map) {
          final vmc = vMessage['content'];
          if (vmc is String) return vmc;
          if (vmc is List) {
            final parts = vmc
                .map((e) => e is Map && e['text'] is String ? e['text'] as String : (e is String ? e : ''))
                .where((s) => s.isNotEmpty)
                .cast<String>()
                .toList();
            return parts.join('');
          }
        }

        // delta
        final vDelta = c['delta'];
        if (vDelta is Map) {
          final dContent = vDelta['content'];
          if (dContent is String) return dContent;
          if (dContent is List) {
            final parts = dContent
                .map((e) => e is Map && e['text'] is String ? e['text'] as String : (e is String ? e : ''))
                .where((s) => s.isNotEmpty)
                .cast<String>()
                .toList();
            return parts.join('');
          }
        }
        // fallback: serialize
        return jsonEncode(c);
      }
      if (c is List) {
        final parts = c.map((e) => e is String ? e : (e is Map && e['text'] is String ? e['text'] as String : '')).where((s) => s.isNotEmpty).toList();
        return parts.join('');
      }
      return c.toString();
    }

    content = extractFrom(candidate);
    // Normalizar posibles codificaciones: double-escaped unicode ("\\uXXXX"), base64,
    // percent-encoding, HTML numeric entities y posible latin1->utf8.
    String normalize(String s) {
      var out = s;

      // 1) Unescape JSON-style (doble-escaped \uXXXX, \n, etc.)
      if (out.contains(r'\\u') || out.contains(r'\\n') || out.contains(r'\\t') || out.contains('\\')) {
        try {
          final decoded = jsonDecode('"' + out.replaceAll('"', '\\"') + '"');
          if (decoded is String && decoded.isNotEmpty) out = decoded;
        } catch (_) {
          // ignore
        }
      }

      // 2) Percent-decoding (por si viene como %D1%88 etc.)
      try {
        if (out.contains('%')) {
          final pct = Uri.decodeComponent(out);
          if (pct.isNotEmpty) out = pct;
        }
      } catch (_) {}

      // 3) HTML numeric entities: decimal &#1234; and hex &#x4D2;
      try {
        out = out.replaceAllMapped(RegExp(r'&#x([0-9A-Fa-f]+);'), (m) {
          final code = int.tryParse(m[1]!, radix: 16);
          return code != null ? String.fromCharCode(code) : m[0]!;
        });
        out = out.replaceAllMapped(RegExp(r'&#(\d+);'), (m) {
          final code = int.tryParse(m[1]!);
          return code != null ? String.fromCharCode(code) : m[0]!;
        });
      } catch (_) {}

      // 4) Base64 heuristic: si parece base64, decodificar y preferir si contiene cirílico
      try {
        final base64Reg = RegExp(r'^[A-Za-z0-9+/=\s]+$');
        final cleaned = out.replaceAll('\n', '').trim();
        if (cleaned.length % 4 == 0 && base64Reg.hasMatch(cleaned)) {
          final bytes = base64Decode(cleaned);
          final decoded = utf8.decode(bytes, allowMalformed: true);
          if (RegExp(r'[\u0400-\u04FF]').hasMatch(decoded)) out = decoded;
        }
      } catch (_) {}

      // 5) Heurística: si tras todo sigue ilegible, intentar interpretar como Latin1 bytes -> utf8
      try {
        // detectar caracteres típicos ilegibles: muchos � o secuencias de bytes fuera de UTF-8
        if (RegExp(r'[�\x80-\x9F]').hasMatch(out)) {
          final bytes = latin1.encode(out);
          final decoded = utf8.decode(bytes, allowMalformed: true);
          if (decoded.isNotEmpty) out = decoded;
        }
      } catch (_) {}

      // 6) Corregir mojibake común: cuando UTF-8 se interpretó como Latin1 (ej. 'Ã±' en lugar de 'ñ')
      try {
        // heurística: si contiene la secuencia típica 'Ã' seguida de otro byte o el caracter 'Â'
        if (out.contains('Ã') || out.contains('Â')) {
          final bytes = latin1.encode(out);
          final decoded = utf8.decode(bytes, allowMalformed: true);
          // Si el resultado contiene caracteres españoles acentuados o ñ, preferirlo
          if (RegExp(r'[ñÑáéíóúÁÉÍÓÚ]').hasMatch(decoded)) {
            out = decoded;
          }
        }
      } catch (_) {}

      return out;
    }

    content = normalize(content).trim();
    // as extra fallback, look for top-level 'choices' in case the passed map is a wrapper
    if (content.isEmpty && map.containsKey('choices') && map['choices'] is List && (map['choices'] as List).isNotEmpty) {
      final first = (map['choices'] as List).first;
      if (first is Map) content = extractFrom(first);
    }

    content = content.trim();

    return ChatChoice(role: role, content: content);
  }
}

class ChatResponse {
  final List<ChatChoice> choices;
  final Map<String, dynamic>? raw;

  ChatResponse({required this.choices, this.raw});

  factory ChatResponse.fromMap(Map<String, dynamic> map) {
    final choicesData = map['choices'] as List<dynamic>? ?? [];
    final choices = choicesData
        .map((c) => c is Map ? ChatChoice.fromMap(Map<String, dynamic>.from(c)) : ChatChoice(role: 'assistant', content: c.toString()))
        .toList();
    return ChatResponse(choices: choices, raw: map);
  }
}
