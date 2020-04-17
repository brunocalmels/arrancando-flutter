import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/views/content_wrapper/show/images_slider/_slider_thumb.dart';
import 'package:flutter/material.dart';
import 'package:snaplist/snaplist.dart';

class ImagesSlider extends StatefulWidget {
  final List<String> images;
  final Map<String, String> videoThumbs;

  ImagesSlider({
    @required this.images,
    @required this.videoThumbs,
  });

  @override
  _ImagesSliderState createState() => _ImagesSliderState();
}

class _ImagesSliderState extends State<ImagesSlider> {
  int _activeImage = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 200,
          child: SnapList(
            sizeProvider: (index, data) => Size(
              MediaQuery.of(context).size.width * 0.8,
              200,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
            ),
            positionUpdate: (index) {
              _activeImage = index + 1;
              if (mounted) setState(() {});
            },
            separatorProvider: (index, data) =>
                Size(MediaQuery.of(context).size.width * 0.15, 30),
            builder: (context, index, data) => SliderThumb(
              src: [
                'mp4',
                'mpg',
                'mpeg'
              ].contains(widget.images[index].split('.').last.toLowerCase())
                  ? "${MyGlobals.SERVER_URL}${widget.videoThumbs[widget.images[index]]}"
                  : "${MyGlobals.SERVER_URL}${widget.images[index]}",
              esVideo: ['mp4', 'mpg', 'mpeg']
                  .contains(widget.images[index].split('.').last.toLowerCase()),
            ),
            count: widget.images.length,
          ),
        ),
        SizedBox(
          height: 7,
        ),
        Text(
          "$_activeImage/${widget.images.length}",
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
