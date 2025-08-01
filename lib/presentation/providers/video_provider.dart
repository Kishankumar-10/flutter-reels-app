import 'package:flutter/foundation.dart';
import '../../domain/entities/video_entity.dart';
import '../../domain/usecases/get_videos_usecase.dart';

enum VideoLoadingState { initial, loading, loaded, error }

class VideoProvider extends ChangeNotifier {
  final GetVideosUseCase getVideosUseCase;

  VideoProvider(this.getVideosUseCase);

  final List<VideoEntity> _videos = [];
  VideoLoadingState _state = VideoLoadingState.initial;
  String _errorMessage = '';
  int _currentPage = 1;
  bool _hasMoreVideos = true;
  bool _isLoadingMore = false;

  List<VideoEntity> get videos => _videos;
  VideoLoadingState get state => _state;
  String get errorMessage => _errorMessage;
  bool get hasMoreVideos => _hasMoreVideos;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> loadVideos(List<String> categories, {bool refresh = false}) async {
    if (refresh) {
      _videos.clear();
      _currentPage = 1;
      _hasMoreVideos = true;
    }
    
    if (_state == VideoLoadingState.loading || !_hasMoreVideos) return;

    _state = VideoLoadingState.loading;
    notifyListeners();

    try {
      final List<VideoEntity> allVideos = [];
      
      for (final category in categories) {
        final result = await getVideosUseCase(GetVideosParams(
          category: category, 
          page: _currentPage,
          perPage: 5
        ));
        result.fold(
          (failure) => throw Exception(failure.message),
          (videos) => allVideos.addAll(videos),
        );
      }

      if (allVideos.isEmpty) {
        _hasMoreVideos = false;
      } else {
        _videos.addAll(allVideos);
        _currentPage++;
      }
      
      _state = VideoLoadingState.loaded;
    } catch (e) {
      _state = VideoLoadingState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> loadMoreVideos(List<String> categories) async {
    if (_isLoadingMore || !_hasMoreVideos || _state == VideoLoadingState.loading) return;
    
    _isLoadingMore = true;
    notifyListeners();
    
    try {
      final List<VideoEntity> allVideos = [];
      
      for (final category in categories) {
        final result = await getVideosUseCase(GetVideosParams(
          category: category, 
          page: _currentPage,
          perPage: 5
        ));
        result.fold(
          (failure) => throw Exception(failure.message),
          (videos) => allVideos.addAll(videos),
        );
      }

      if (allVideos.isEmpty) {
        _hasMoreVideos = false;
      } else {
        _videos.addAll(allVideos);
        _currentPage++;
      }
    } catch (e) {
      debugPrint('Error loading more videos: $e');
    }
    
    _isLoadingMore = false;
    notifyListeners();
  }

  void clearVideos() {
    _videos.clear();
    _currentPage = 1;
    _hasMoreVideos = true;
    _isLoadingMore = false;
    _state = VideoLoadingState.initial;
    notifyListeners();
  }
}