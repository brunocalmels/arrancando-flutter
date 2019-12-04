import 'dart:io';

import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/views/content_wrapper/show/_image_large.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ImageSlider extends StatefulWidget {
  final List<String> images;

  ImageSlider({
    @required this.images,
  });

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _activeImage = 0;
  Map<String, File> _videoThumbs = {};

  _getVideosThumbs() async {
    _videoThumbs = {};
    String thumbPath = (await getTemporaryDirectory()).path;
    List<String> vids = widget.images
        .where((i) =>
            ['mp4', 'mpg', 'mpeg'].contains(i.split('.').last.toLowerCase()))
        .toList();

    await Future.wait(
      vids.map(
        (v) async {
          _videoThumbs[v] = File(
            await VideoThumbnail.thumbnailFile(
              video: "${MyGlobals.SERVER_URL}$v",
              thumbnailPath: thumbPath,
              imageFormat: ImageFormat.JPEG,
              maxHeightOrWidth: 250,
              quality: 50,
            ),
          );
        },
      ),
    );
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(ImageSlider oldWidget) {
    if (oldWidget.images.length != widget.images.length) {
      _activeImage = 0;
      if (mounted) setState(() {});
      _getVideosThumbs();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 1));
      _getVideosThumbs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ImageLarge(
              tag: "${MyGlobals.SERVER_URL}${widget.images[_activeImage]}",
              url: "${MyGlobals.SERVER_URL}${widget.images[_activeImage]}",
            ),
          ),
        );
      },
      onPanEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx > 0) {
          if (_activeImage > 0) {
            _activeImage = _activeImage - 1;
          }
        } else {
          if (_activeImage < widget.images.length - 1) {
            _activeImage = _activeImage + 1;
          }
        }
        setState(() {});
      },
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Positioned.fill(
            child: ['mp4', 'mpg', 'mpeg'].contains(
                    widget.images[_activeImage].split('.').last.toLowerCase())
                ? _videoThumbs[widget.images[_activeImage]] == null
                    ? SizedBox(
                        height: 25,
                        width: 25,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : Stack(
                        fit: StackFit.passthrough,
                        children: <Widget>[
                          Image.file(_videoThumbs[widget.images[_activeImage]]),
                          // Container(
                          //   color: Colors.white38,
                          // ),
                          Center(
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ),
                          )
                        ],
                      )
                : Image.network(
                    "${MyGlobals.SERVER_URL}${widget.images[_activeImage]}",
                  ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "${_activeImage + 1}/${widget.images.length}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
