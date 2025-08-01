import '../../core/network/api_client.dart';
import '../../data/datasources/video_remote_datasource.dart';
import '../../data/repositories/video_repository_impl.dart';
import '../../domain/usecases/get_videos_usecase.dart';
import '../../presentation/providers/category_provider.dart';
import '../../presentation/providers/video_provider.dart';

class InjectionContainer {
  static late CategoryProvider _categoryProvider;
  static late VideoProvider _videoProvider;

  static void init() {
    final apiClient = ApiClient();
    final dataSource = VideoRemoteDataSourceImpl(apiClient);
    final repository = VideoRepositoryImpl(dataSource);
    final useCase = GetVideosUseCase(repository);
    
    _categoryProvider = CategoryProvider();
    _videoProvider = VideoProvider(useCase);
  }

  static CategoryProvider get categoryProvider => _categoryProvider;
  static VideoProvider get videoProvider => _videoProvider;
}