import 'package:arrancando/views/content_wrapper/show/_image_large.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SliderThumb extends StatelessWidget {
  final String src;
  final String originalSrc;
  final bool esVideo;

  SliderThumb({
    @required this.src,
    this.originalSrc,
    this.esVideo = false,
  });

  @override
  Widget build(BuildContext context) {
    return src == null
        ? SizedBox(
            height: 25,
            width: 25,
            child: Center(
              child: Text(
                ". . .",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        : Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                child: esVideo
                    ? Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: src,
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
                          Center(
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 65,
                            ),
                          )
                        ],
                      )
                    : CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: src,
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
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  type: MaterialType.card,
                  child: InkWell(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ImageLarge(
                            tag: esVideo && originalSrc != null
                                ? originalSrc
                                : src,
                            url: esVideo && originalSrc != null
                                ? originalSrc
                                : src,
                          ),
                          settings: RouteSettings(name: 'ImageViewer'),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
  }
}
