import '../../core/network/api_client.dart';
import '../models/video_model.dart';

abstract class VideoRemoteDataSource {
  Future<List<VideoModel>> getVideosByCategory(String category, {int page = 1, int perPage = 10});
}

class VideoRemoteDataSourceImpl implements VideoRemoteDataSource {
  final ApiClient apiClient;

  VideoRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<VideoModel>> getVideosByCategory(String category, {int page = 1, int perPage = 10}) async {
    final response = await apiClient.get('/search', queryParameters: {
      'query': category,
      'page': page,
      'per_page': perPage,
      'orientation': 'portrait',
    });

    final videos = response.data['videos'] as List;
    return videos.map((json) => VideoModel.fromJson(json)).toList();
  }
}