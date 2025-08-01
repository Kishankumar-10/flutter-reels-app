import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/video_provider.dart';
import '../providers/category_provider.dart';
import 'video_player_widget.dart';

class VideoFeed extends StatefulWidget {
  const VideoFeed({super.key});

  @override
  State<VideoFeed> createState() => _VideoFeedState();
}

class _VideoFeedState extends State<VideoFeed> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoProvider>(
      builder: (context, videoProvider, child) {
        if (videoProvider.state == VideoLoadingState.loading && videoProvider.videos.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }

        if (videoProvider.state == VideoLoadingState.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.white, size: 64),
                const SizedBox(height: 16),
                const Text('Failed to load videos', style: TextStyle(color: Colors.white, fontSize: 18)),
              ],
            ),
          );
        }

        if (videoProvider.videos.isEmpty) {
          return const Center(child: Text('No videos available', style: TextStyle(color: Colors.white, fontSize: 18)));
        }

        return PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
            
            // Load more videos when near the end
            if (index >= videoProvider.videos.length - 2) {
              _loadMoreVideos();
            }
          },
          itemCount: videoProvider.videos.length,
          itemBuilder: (context, index) {
            final video = videoProvider.videos[index];
            return VideoPlayerWidget(video: video, isActive: index == _currentIndex);
          },
        );
      },
    );
  }

  Future<void> _loadMoreVideos() async {
    if (!mounted) return;
    
    final categoryProvider = context.read<CategoryProvider>();
    final videoProvider = context.read<VideoProvider>();
    
    if (categoryProvider.selectedCategories.isNotEmpty) {
      await videoProvider.loadMoreVideos(categoryProvider.selectedCategories);
    }
  }
}