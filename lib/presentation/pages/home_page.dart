import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../providers/video_provider.dart';
import '../widgets/video_feed.dart';
import 'category_selection_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVideos();
    });
  }

  Future<void> _loadVideos() async {
    final categoryProvider = context.read<CategoryProvider>();
    final videoProvider = context.read<VideoProvider>();
    
    // Ensure preferences are loaded first
    await categoryProvider.loadPreferences();
    
    if (categoryProvider.selectedCategories.isNotEmpty) {
      await videoProvider.loadVideos(categoryProvider.selectedCategories, refresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          final videoProvider = context.read<VideoProvider>();
          videoProvider.clearVideos();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const CategorySelectionPage()),
          );
        }
      },
      child: const Scaffold(
        backgroundColor: Colors.black,
        body: VideoFeed(),
      ),
    );
  }
}