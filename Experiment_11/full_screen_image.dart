// screens/full_screen_image.dart
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FullScreenImage extends StatelessWidget {
  final String url;
  final String photographer;

  const FullScreenImage({Key? key, required this.url, required this.photographer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(photographer),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(url),
          loadingBuilder: (context, event) => const Center(child: CircularProgressIndicator()),
          backgroundDecoration: const BoxDecoration(color: Colors.black),
        ),
      ),
    );
  }
}
