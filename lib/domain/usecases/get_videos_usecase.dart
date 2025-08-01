import '../entities/video_entity.dart';
import '../repositories/video_repository.dart';
import '../../core/errors/failures.dart';

class GetVideosUseCase {
  final VideoRepository repository;

  GetVideosUseCase(this.repository);

  Future<Either<Failure, List<VideoEntity>>> call(GetVideosParams params) {
    return repository.getVideosByCategory(params.category, page: params.page, perPage: params.perPage);
  }
}

class GetVideosParams {
  final String category;
  final int page;
  final int perPage;

  GetVideosParams({required this.category, this.page = 1, this.perPage = 10});
}