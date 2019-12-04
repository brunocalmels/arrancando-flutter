import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ImageLarge extends StatefulWidget {
  final String tag;
  final String url;

  ImageLarge({
    this.tag,
    this.url,
  });

  @override
  _ImageLargeState createState() => _ImageLargeState();
}

class _ImageLargeState extends State<ImageLarge> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (['mp4', 'mpg', 'mpeg']
          .contains(widget.url.split('.').last.toLowerCase()))
        _controller = VideoPlayerController.network(widget.url)
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
            _controller.play();
          });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
      body: ['mp4', 'mpg', 'mpeg']
              .contains(widget.url.split('.').last.toLowerCase())
          ? Center(
              child: _controller != null &&
                      _controller.value != null &&
                      _controller.value.initialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
            )
          : Container(
              child: Center(
                child: Image.network(widget.url),
              ),
            ),
    );
  }
}
