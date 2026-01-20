import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:practicas/features/chutes_chat/models/chat_response.dart';
import 'package:practicas/features/chutes_chat/models/chat_message.dart';

class ChutesApiException implements Exception {
  final String message;
  ChutesApiException(this.message);
  @override
  String toString() => 'ChutesApiException: $message';
}

class ChutesApiService {
  final String apiKey;
  final Uri url;
  final http.Client client;
  final Duration timeout;
  final bool debug;

  ChutesApiService({
    required this.apiKey,
    required this.url,
    http.Client? client,
    Duration? timeout,
    this.debug = false,
  })  : client = client ?? http.Client(),
        timeout = timeout ?? const Duration(seconds: 30);

  Future<ChatResponse> createChatCompletion({
    required List<ChatMessage> messages,
    required String model,
    double temperature = 0.0,
    int maxTokens = 1024,
    bool stream = false,
  }) async {
    if (apiKey.isEmpty) throw ChutesApiException('API key is empty');
    if (messages.isEmpty) throw ChutesApiException('messages cannot be empty');

    final payload = {
      'model': model,
      'messages': messages
          .map((m) => {'role': m.role, 'content': m.content})
          .toList(),
      'temperature': temperature,
      'max_tokens': maxTokens,
      'stream': stream,
    };

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $apiKey',
    };

    try {
      final response = await client
          .post(url, headers: headers, body: jsonEncode(payload))
          .timeout(timeout);

      if (debug) {
        // imprimir info útil de depuración (NO imprimir apiKey)
        log('ChutesApiService DEBUG -- status: ${response.statusCode}');
        log('ChutesApiService DEBUG -- body: ${response.body}');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return ChatResponse.fromMap(data);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw ChutesApiException('Authentication failed (${response.statusCode})');
      } else if (response.statusCode == 429) {
        throw ChutesApiException('Rate limit exceeded (429)');
      } else {
        throw ChutesApiException('HTTP ${response.statusCode}: ${response.body}');
      }
    } on SocketException catch (e) {
      throw ChutesApiException('Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ChutesApiException('Response format error: ${e.message}');
    } on TimeoutException catch (_) {
      throw ChutesApiException('Request timed out');
    }
  }
}
