import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class StoryViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('stories').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No stories available'));
        }

        final stories = snapshot.data!.docs;

        return SizedBox(
          height: 180, // Height to accommodate the story and vendor name
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];
              final vendorName = story['vendorName'] ?? 'Unknown';
              final imageUrl = story['imageUrl'];
              final videoUrl = story['videoUrl'];

              final defaultImageUrl = 'https://example.com/default_profile.png'; // Replace with your default image URL

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen(
                        stories: stories, // Pass the entire list of stories
                        initialIndex: index, // Pass the index of the selected story
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 120, // Width of each story item
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10), // Increased margin for more space
                  padding: EdgeInsets.all(0), // Remove padding to avoid extra space
                  decoration: BoxDecoration(
                    color: Colors.black, // Background color for the story container
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    border: Border.all(color: Colors.red, width: 2), // Red border
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8), // Rounded corners for the image
                        child: Container(
                          width: 150, // Adjusted width to match the container
                          height: 230, // Adjusted height to match the container
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageUrl != null && imageUrl.isNotEmpty
                                  ? NetworkImage(imageUrl)
                                  : NetworkImage(defaultImageUrl),
                              fit: BoxFit.cover, // Ensures the image covers the entire container
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2), // Space between the image and vendor name
                      Text(
                        vendorName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12, // Slightly larger font size
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final List<DocumentSnapshot> stories;
  final int initialIndex;

  const VideoPlayerScreen({required this.stories, required this.initialIndex});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Story'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.stories.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final story = widget.stories[index];
          final videoUrl = story['videoUrl'];

          return VideoPlayerWidget(videoUrl: videoUrl);
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isError = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.videoUrl)
      ..addListener(() {
        if (_controller.value.hasError) {
          setState(() {
            _isError = true;
          });
        } else {
          setState(() {
            _isPlaying = _controller.value.isPlaying;
          });
        }
      })
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = _controller.value.isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      return Center(
        child: Text(
          'Error loading video',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return _controller.value.isInitialized
        ? Stack(
      children: [
        Center(child: VideoPlayer(_controller)),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
              color: Colors.white,
              size: 30,
            ),
            onPressed: _togglePlayPause,
          ),
        ),
      ],
    )
        : Center(child: CircularProgressIndicator());
  }
}
