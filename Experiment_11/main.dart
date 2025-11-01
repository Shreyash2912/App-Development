// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_client.dart';
import 'repository/wallpaper_repository.dart';
import 'viewmodel/wallpaper_viewmodel.dart';
import 'screens/wallpaper_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // TODO: Replace with your Pexels API key. Keep it secret!
  static const String _pexelsApiKey = 'R6yM96ZIyaADCyn954Y3ZNZNTnId7kgm7wttAb9kxLS2jsuzHqup50xt';

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient(apiKey: _pexelsApiKey);
    final repo = WallpaperRepository(apiClient: apiClient);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WallpaperViewModel(repository: repo),
        ),
      ],
      child: MaterialApp(
        title: 'Pexels Wallpapers',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const WallpaperScreen(),
      ),
    );
  }
}
