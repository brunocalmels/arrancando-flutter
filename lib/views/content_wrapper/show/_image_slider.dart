import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/views/content_wrapper/show/_image_large.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  final List<String> images;
  final Map<String, String> videoThumbs;

  ImageSlider({
    @required this.images,
    @required this.videoThumbs,
  });

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _activeImage = 0;
  // Map<String, File> _videoThumbs = {};

  // Future<void> _getVideosThumbs() async {
  //   _videoThumbs = {};
  //   String thumbPath = (await getTemporaryDirectory()).path;
  //   List<String> vids = widget.images
  //       .where((i) =>
  //           MyGlobals.VIDEO_FORMATS.contains(i.split('.').last.toLowerCase()))
  //       .toList();

  //   await Future.wait(
  //     vids.map(
  //       (v) async {
  //         String filename = v.split('/').last;
  //         filename = filename.replaceRange(
  //           filename[filename.length - 4] == '.'
  //               ? filename.length - 3
  //               : filename.length - 4,
  //           filename.length,
  //           'jpg',
  //         );
  //         File thumb = File('$thumbPath/$filename');
  //         if (thumb.existsSync()) {
  //           _videoThumbs[v] = thumb;
  //         } else {
  //           _videoThumbs[v] = File(
  //             await VideoThumbnail.thumbnailFile(
  //               video: '${MyGlobals.SERVER_URL}$v',
  //               thumbnailPath: thumbPath,
  //               imageFormat: ImageFormat.JPEG,
  //               maxHeightOrWidth: 350,
  //               quality: 70,
  //             ),
  //           );
  //         }
  //       },
  //     ),
  //   );
  //   if (mounted) setState(() {});
  // }

  @override
  void didUpdateWidget(ImageSlider oldWidget) {
    if (oldWidget.images.length != widget.images.length) {
      _activeImage = 0;
      if (mounted) setState(() {});
      // _getVideosThumbs();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 1));
      // _getVideosThumbs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ImageLarge(
              tag: '${MyGlobals.SERVER_URL}${widget.images[_activeImage]}',
              url: '${MyGlobals.SERVER_URL}${widget.images[_activeImage]}',
            ),
            settings: RouteSettings(name: 'ImageViewer'),
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
            child: MyGlobals.VIDEO_FORMATS.contains(
                    widget.images[_activeImage].split('.').last.toLowerCase())
                ? widget.videoThumbs[widget.images[_activeImage]] == null
                    ? SizedBox(
                        height: 25,
                        width: 25,
                        child: Center(
                          // child: CircularProgressIndicator(
                          //   strokeWidth: 2,
                          // ),
                          child: Text(
                            '. . .',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    : Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          // Image.file(_videoThumbs[widget.images[_activeImage]]),
                          CachedNetworkImage(
                            fit: BoxFit.contain,
                            imageUrl:
                                '${MyGlobals.SERVER_URL}${widget.videoThumbs[widget.images[_activeImage]]}',
                            placeholder: (context, url) => Center(
                              child: SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          // Container(
                          //   color: Colors.white38,
                          // ),
                          Center(
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 65,
                            ),
                          )
                        ],
                      )
                // : Image.network(
                //     '${MyGlobals.SERVER_URL}${widget.images[_activeImage]}',
                //   ),
                : CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl:
                        '${MyGlobals.SERVER_URL}${widget.images[_activeImage]}',
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
          Positioned(
            left: 0,
            right: 0,
            bottom: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${_activeImage + 1}/${widget.images.length}',
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
