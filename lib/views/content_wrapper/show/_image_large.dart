import 'package:cached_network_image/cached_network_image.dart';
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
  double _scale = 1;
  bool _isPlaying = false;

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
            _controller.setLooping(true);
            _isPlaying = true;
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
          ? GestureDetector(
              onTap: () {
                if (_controller != null) {
                  if (_isPlaying) {
                    _controller.pause();
                    _isPlaying = false;
                  } else {
                    _controller.play();
                    _isPlaying = true;
                  }
                  if (mounted) setState(() {});
                }
              },
              child: Stack(
                fit: StackFit.passthrough,
                children: <Widget>[
                  Center(
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
                  ),
                  if (_controller != null && !_isPlaying)
                    Positioned.fill(
                      child: Center(
                        child: Icon(
                          Icons.play_arrow,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            )
          : GestureDetector(
              onScaleUpdate: (details) {
                _scale = details.scale;
                if (mounted) setState(() {});
              },
              onScaleEnd: (details) {
                _scale = 1;
                if (mounted) setState(() {});
              },
              child: Container(
                child: Center(
                  child: Transform.scale(
                    scale: _scale,
                    // child: Image.network(
                    //   widget.url,
                    // ),
                    child: CachedNetworkImage(
                      imageUrl: widget.url,
                      placeholder: (context, url) => Center(
                        child: SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
