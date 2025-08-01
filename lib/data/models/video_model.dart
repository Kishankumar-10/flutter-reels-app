import '../../domain/entities/video_entity.dart';

class VideoModel extends VideoEntity {
  const VideoModel({
    required super.id,
    required super.url,
    required super.thumbnailUrl,
    required super.duration,
    super.description,
    required super.user,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    final videoFiles = json['video_files'] as List;
    final hdVideo = videoFiles.firstWhere((file) => file['quality'] == 'hd', orElse: () => videoFiles.first);

    return VideoModel(
      id: json['id'],
      url: hdVideo['link'],
      thumbnailUrl: json['image'],
      duration: json['duration'] ?? 0,
      description: json['tags']?.join(', '),
      user: VideoUserModel.fromJson(json['user']),
    );
  }
}

class VideoUserModel extends VideoUser {
  const VideoUserModel({required super.id, required super.name, super.profileUrl});

  factory VideoUserModel.fromJson(Map<String, dynamic> json) {
    return VideoUserModel(id: json['id'], name: json['name'], profileUrl: json['url']);
  }
}