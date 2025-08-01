class VideoEntity {
  final int id;
  final String url;
  final String thumbnailUrl;
  final int duration;
  final String? description;
  final VideoUser user;

  const VideoEntity({
    required this.id,
    required this.url,
    required this.thumbnailUrl,
    required this.duration,
    this.description,
    required this.user,
  });
}

class VideoUser {
  final int id;
  final String name;
  final String? profileUrl;

  const VideoUser({
    required this.id,
    required this.name,
    this.profileUrl,
  });
}