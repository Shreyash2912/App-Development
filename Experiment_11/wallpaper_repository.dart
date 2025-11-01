// repository/wallpaper_repository.dart
import 'dart:convert';
import '../models/wallpaper.dart';
import '../services/api_client.dart';

class WallpaperRepository {
  final ApiClient apiClient;

  WallpaperRepository({required this.apiClient});

  /// Fetch curated wallpapers (Pexels curated endpoint)
  Future<List<Wallpaper>> fetchCurated({int page = 1, int perPage = 30}) async {
    final resp = await apiClient.get('/curated', {
      'page': page.toString(),
      'per_page': perPage.toString(),
    });

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final Map<String, dynamic> data = json.decode(resp.body);
      final photos = data['photos'] as List<dynamic>? ?? [];
      return photos.map((p) => Wallpaper.fromJson(p as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load wallpapers: ${resp.statusCode}');
    }
  }

  /// Optionally: search
  Future<List<Wallpaper>> search({required String query, int page = 1, int perPage = 30}) async {
    final resp = await apiClient.get('/search', {
      'query': query,
      'page': page.toString(),
      'per_page': perPage.toString(),
    });

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final Map<String, dynamic> data = json.decode(resp.body);
      final photos = data['photos'] as List<dynamic>? ?? [];
      return photos.map((p) => Wallpaper.fromJson(p as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Search failed: ${resp.statusCode}');
    }
  }
}
