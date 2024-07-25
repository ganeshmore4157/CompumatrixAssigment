import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeVideoListPage extends StatefulWidget {
  @override
  _YouTubeVideoListPageState createState() => _YouTubeVideoListPageState();
}

class _YouTubeVideoListPageState extends State<YouTubeVideoListPage> {
  final List<Map<String, String>> videos = [
    {
      'title': 'Zee News Live'.tr,
      'url': 'https://www.youtube.com/watch?v=IxsEZWnn_wU',
    },
    {
      'title': 'Tv9 Marathi Live'.tr,
      'url': 'https://www.youtube.com/watch?v=UcQUKAv45sM',
    },
    {
      'title': 'ABP News Live'.tr,
      'url': 'https://www.youtube.com/watch?v=exXZqBUqVWw',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Youtube Live News'.tr),
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(video['title']!),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YouTubeVideoPlayerPage(videoUrl: video['url']!),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class YouTubeVideoPlayerPage extends StatefulWidget {
  final String videoUrl;

  YouTubeVideoPlayerPage({required this.videoUrl});

  @override
  _YouTubeVideoPlayerPageState createState() => _YouTubeVideoPlayerPageState();
}

class _YouTubeVideoPlayerPageState extends State<YouTubeVideoPlayerPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl)!,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Play Video'),
      ),
      body: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        onReady: () {
          _controller.addListener(() {});
        },
      ),
    );
  }
}
