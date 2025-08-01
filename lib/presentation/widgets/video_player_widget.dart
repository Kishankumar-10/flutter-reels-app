import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/video_entity.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoEntity video;
  final bool isActive;

  const VideoPlayerWidget({super.key, required this.video, required this.isActive});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isLiked = false;
  int _likeCount = 0;
  int _commentCount = 0;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _likeCount = (widget.video.id % 100) + 10; // Random like count
    _commentCount = (widget.video.id % 50) + 5; // Random comment count
    _initializeAudioSession();
    _initializeVideo();
  }

  Future<void> _initializeAudioSession() async {
    try {
      // Set audio mode to normal playback
      await SystemChannels.platform.invokeMethod('SystemSound.play', 'SystemSoundType.click');
      debugPrint('Audio session initialized');
    } catch (e) {
      debugPrint('Audio session initialization failed: $e');
    }
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller?.play();
        setState(() => _isPlaying = true);
      } else {
        _controller?.pause();
        setState(() => _isPlaying = false);
      }
    }
  }

  Future<void> _initializeVideo() async {
    // Mix original Pexels videos with some audio test videos
    String videoUrl = widget.video.url;
    
    // Add audio to some videos for testing (every 3rd video gets audio)
    if (widget.video.id % 3 == 0) {
      final audioVideos = [
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
      ];
      videoUrl = audioVideos[widget.video.id % audioVideos.length];
    }
    
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: false,
        allowBackgroundPlayback: false,
      ),
    );
    
    try {
      await _controller!.initialize();
      _controller!.setLooping(true);
      
      // Set volume
      await _controller!.setVolume(_isMuted ? 0.0 : 1.0);
      
      debugPrint('Video ID: ${widget.video.id}');
      debugPrint('Video URL: $videoUrl');
      debugPrint('Has Audio: ${widget.video.id % 3 == 0 ? "YES" : "MAYBE"}');
      debugPrint('Volume: ${_isMuted ? 0.0 : 1.0}');
      
      if (widget.isActive) {
        await _controller!.play();
        setState(() => _isPlaying = true);
      }
      
      setState(() => _isInitialized = true);
    } catch (e) {
      debugPrint('Error initializing video: $e');
    }
  }

  void _togglePlayPause() {
    if (_controller == null) return;
    
    setState(() {
      if (_isPlaying) {
        _controller!.pause();
        _isPlaying = false;
      } else {
        _controller!.play();
        _isPlaying = true;
      }
    });
  }

  Widget _buildActionButton(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.red : Colors.white,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
  }

  void _toggleVolume() {
    if (_controller != null) {
      setState(() {
        _isMuted = !_isMuted;
        _controller!.setVolume(_isMuted ? 0.0 : 1.0);
      });
      debugPrint('Volume toggled: ${_isMuted ? "Muted" : "Unmuted"} - Volume: ${_isMuted ? 0.0 : 1.0}');
    }
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.comment, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Comments',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: 8,
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.purple, Colors.blue],
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.person, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'User${index + 1}',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ['Amazing content! 🔥', 'Love this! ❤️', 'So cool! 😍', 'Great work! 👏', 'Awesome! 🚀'][index % 5],
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Full screen video with gradient overlay
        if (_isInitialized && _controller != null)
          Stack(
            fit: StackFit.expand,
            children: [
              // Full screen video coverage
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.size.width,
                    height: _controller!.value.size.height,
                    child: VideoPlayer(_controller!),
                  ),
                ),
              ),
              // Gradient overlay for better text visibility
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.0, 0.5, 0.8, 1.0],
                  ),
                ),
              ),
            ],
          )
        else
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
          ),

        GestureDetector(
          onTap: _togglePlayPause,
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: AnimatedOpacity(
                opacity: _isPlaying ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 80),
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 100,
          left: 16,
          right: 100,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '@${widget.video.user.name}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                if (widget.video.description != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    widget.video.description!,
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),

        Positioned(
          bottom: 100,
          right: 16,
          child: Column(
            children: [
              _buildActionButton(Icons.favorite, '${_likeCount}K', _isLiked, _toggleLike),
              const SizedBox(height: 20),
              _buildActionButton(Icons.comment, '$_commentCount', false, _showComments),
              const SizedBox(height: 20),
              _buildActionButton(
                _isMuted ? Icons.volume_off : Icons.volume_up,
                _isMuted ? 'Muted' : 'Sound',
                false,
                _toggleVolume,
              ),
              const SizedBox(height: 20),
              _buildActionButton(Icons.share, 'Share', false, () {}),
            ],
          ),
        ),
      ],
    );
  }
}