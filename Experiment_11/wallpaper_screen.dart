// screens/wallpaper_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../viewmodel/wallpaper_viewmodel.dart';
import 'full_screen_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class WallpaperScreen extends StatefulWidget {
  const WallpaperScreen({Key? key}) : super(key: key);

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final vm = context.read<WallpaperViewModel>();
    vm.loadInitial();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        // near bottom
        vm.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await context.read<WallpaperViewModel>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pexels Wallpapers')),
      body: Consumer<WallpaperViewModel>(
        builder: (context, vm, child) {
          if (vm.state == ViewState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (vm.state == ViewState.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: ${vm.error ?? "Unknown"}'),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: vm.loadInitial, child: const Text('Retry'))
                ],
              ),
            );
          } else if (vm.state == ViewState.empty) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView(
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text('No wallpapers found')),
                ],
              ),
            );
          }

          // loaded
          final list = vm.wallpapers;
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: MasonryGridView.count(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemCount: list.length + (vm.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= list.length) {
                  // loader at end for pagination
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final item = list[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => FullScreenImage(url: item.full, photographer: item.photographer),
                    ));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: item.thumbnail,
                      placeholder: (c, u) => Container(
                        color: Colors.grey[300],
                        height: 200,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
