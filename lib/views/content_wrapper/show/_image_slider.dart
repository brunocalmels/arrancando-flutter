import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/views/content_wrapper/show/_image_large.dart';
import 'package:flutter/material.dart';

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

  @override
  void didUpdateWidget(ImageSlider oldWidget) {
    if (oldWidget.images.length != widget.images.length) {
      _activeImage = 0;
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
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
          Image.network(
            "${MyGlobals.SERVER_URL}${widget.images[_activeImage]}",
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
