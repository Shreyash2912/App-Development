// services/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const _baseUrl = 'https://api.pexels.com/v1';
  final String apiKey;

  ApiClient({required this.apiKey});

  Future<http.Response> get(String endpoint, [Map<String, String>? params]) async {
    final uri = Uri.parse('$_baseUrl$endpoint').replace(queryParameters: params);
    final response = await http.get(
      uri,
      headers: {
        'Authorization': apiKey,
        'Accept': 'application/json',
      },
    );
    return response;
  }
}
