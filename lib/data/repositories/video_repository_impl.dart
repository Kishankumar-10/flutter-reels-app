import 'package:dio/dio.dart';
import '../../domain/entities/video_entity.dart';
import '../../domain/repositories/video_repository.dart';
import '../../core/errors/failures.dart';
import '../datasources/video_remote_datasource.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoRemoteDataSource remoteDataSource;

  VideoRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<VideoEntity>>> getVideosByCategory(String category, {int page = 1, int perPage = 10}) async {
    try {
      final videos = await remoteDataSource.getVideosByCategory(category, page: page, perPage: perPage);
      return Either.right(videos);
    } on DioException catch (e) {
      return Either.left(NetworkFailure(e.message ?? 'Network error'));
    } catch (e) {
      return Either.left(ServerFailure('Unexpected error: $e'));
    }
  }
}