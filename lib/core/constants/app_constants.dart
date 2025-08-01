class AppConstants {
  // API Configuration
  static const String pexelsApiKey = 'FALLBACK_KEY'; // Fallback only - use .env file
  static const String pexelsBaseUrl = 'https://api.pexels.com/videos';
  
  // App Configuration
  static const int videosPerPage = 10;
  static const Duration splashDuration = Duration(seconds: 2);
  
  // Storage Keys
  static const String selectedCategoriesKey = 'selected_categories';
  static const String isFirstLaunchKey = 'is_first_launch';
  
  // Video Categories
  static const List<VideoCategory> videoCategories = [
    VideoCategory(
      id: 'comedy',
      name: 'Comedy & Funny',
      searchQuery: 'funny comedy',
      icon: '😂',
    ),
    VideoCategory(
      id: 'entertainment',
      name: 'Entertainment & Trends',
      searchQuery: 'entertainment trending',
      icon: '🎭',
    ),
    VideoCategory(
      id: 'educational',
      name: 'Educational & Informative',
      searchQuery: 'education learning',
      icon: '📚',
    ),
    VideoCategory(
      id: 'inspirational',
      name: 'Inspirational & Motivational',
      searchQuery: 'motivation inspiration',
      icon: '💪',
    ),
    VideoCategory(
      id: 'beauty',
      name: 'Beauty & Fashion',
      searchQuery: 'beauty fashion',
      icon: '💄',
    ),
    VideoCategory(
      id: 'food',
      name: 'Food & Cooking',
      searchQuery: 'food cooking',
      icon: '🍳',
    ),
    VideoCategory(
      id: 'travel',
      name: 'Travel & Adventure',
      searchQuery: 'travel adventure',
      icon: '✈️',
    ),
    VideoCategory(
      id: 'business',
      name: 'Business & Advertising',
      searchQuery: 'business corporate',
      icon: '💼',
    ),
  ];
}

class VideoCategory {
  final String id;
  final String name;
  final String searchQuery;
  final String icon;

  const VideoCategory({
    required this.id,
    required this.name,
    required this.searchQuery,
    required this.icon,
  });
}