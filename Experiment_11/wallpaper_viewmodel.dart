// viewmodel/wallpaper_viewmodel.dart
import 'package:flutter/material.dart';
import '../models/wallpaper.dart';
import '../repository/wallpaper_repository.dart';

enum ViewState { idle, loading, loaded, error, empty }

class WallpaperViewModel extends ChangeNotifier {
  final WallpaperRepository repository;

  WallpaperViewModel({required this.repository});

  List<Wallpaper> _wallpapers = [];
  List<Wallpaper> get wallpapers => _wallpapers;

  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  String? _error;
  String? get error => _error;

  int _page = 1;
  final int _perPage = 30;
  bool _hasMore = true;
  bool get hasMore => _hasMore;
  bool _isLoadingMore = false;

  Future<void> loadInitial() async {
    _page = 1;
    _hasMore = true;
    _wallpapers = [];
    _setState(ViewState.loading);
    try {
      final list = await repository.fetchCurated(page: _page, perPage: _perPage);
      _wallpapers = list;
      _hasMore = list.length >= _perPage;
      _setState(_wallpapers.isEmpty ? ViewState.empty : ViewState.loaded);
    } catch (e) {
      _error = e.toString();
      _setState(ViewState.error);
    }
  }

  Future<void> refresh() async {
    await loadInitial();
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore) return;
    _isLoadingMore = true;
    _page += 1;
    try {
      final more = await repository.fetchCurated(page: _page, perPage: _perPage);
      if (more.isEmpty) {
        _hasMore = false;
      } else {
        _wallpapers.addAll(more);
        _hasMore = more.length >= _perPage;
      }
      _setState(ViewState.loaded);
    } catch (e) {
      _error = e.toString();
      _setState(ViewState.error);
    } finally {
      _isLoadingMore = false;
    }
  }

  void _setState(ViewState s) {
    _state = s;
    notifyListeners();
  }
}
