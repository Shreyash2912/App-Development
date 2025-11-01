// models/wallpaper.dart
class Wallpaper {
  final int id;
  final String photographer;
  final String photographerUrl;
  final String thumbnail; // small/medium
  final String full; // original or large

  Wallpaper({
    required this.id,
    required this.photographer,
    required this.photographerUrl,
    required this.thumbnail,
    required this.full,
  });

  factory Wallpaper.fromJson(Map<String, dynamic> json) {
    final src = json['src'] as Map<String, dynamic>? ?? {};
    return Wallpaper(
      id: json['id'] as int,
      photographer: json['photographer'] as String? ?? '',
      photographerUrl: json['photographer_url'] as String? ?? '',
      thumbnail: src['medium'] as String? ?? src['small'] as String? ?? '',
      full: src['original'] as String? ?? src['large2x'] as String? ?? '',
    );
  }
}
