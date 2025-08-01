import '../entities/video_entity.dart';
import '../../core/errors/failures.dart';

abstract class VideoRepository {
  Future<Either<Failure, List<VideoEntity>>> getVideosByCategory(String category, {int page = 1, int perPage = 10});
}

class Either<L, R> {
  final L? _left;
  final R? _right;
  final bool _isLeft;

  Either.left(L left) : _left = left, _right = null, _isLeft = true;
  Either.right(R right) : _left = null, _right = right, _isLeft = false;

  T fold<T>(T Function(L) leftFn, T Function(R) rightFn) {
    if (_isLeft) {
      return leftFn(_left as L);
    } else {
      return rightFn(_right as R);
    }
  }
}